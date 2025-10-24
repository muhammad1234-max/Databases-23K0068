<?php 
include("php/query.php");

// Handle single record delete
if (isset($_GET['delete_id'])) {
    $id = $_GET['delete_id'];
    // Fetch image filename before deleting record
    $stmt = $pdo->prepare("SELECT image FROM categories WHERE id = ?");
    $stmt->execute([$id]);
    $file = $stmt->fetchColumn();
    if ($file && file_exists("uploads/" . $file)) {
        unlink("uploads/" . $file);
    }

    $stmt = $pdo->prepare("DELETE FROM categories WHERE id = ?");
    $stmt->execute([$id]);
    header("Location: select.php");
    exit;
}

// Handle delete all
if (isset($_GET['delete_all'])) {
    // Delete all images
    $stmt = $pdo->query("SELECT image FROM categories");
    $images = $stmt->fetchAll(PDO::FETCH_COLUMN);
    foreach ($images as $file) {
        if ($file && file_exists("uploads/" . $file)) {
            unlink("uploads/" . $file);
        }
    }
    // Delete all records
    $pdo->query("DELETE FROM categories");
    header("Location: select.php");
    exit;
}

// Handle file-only delete
if (isset($_GET['delete_file'])) {
    $id = $_GET['delete_file'];
    $stmt = $pdo->prepare("SELECT image FROM categories WHERE id = ?");
    $stmt->execute([$id]);
    $file = $stmt->fetchColumn();
    if ($file && file_exists("uploads/" . $file)) {
        unlink("uploads/" . $file);
        // Update DB to clear image column
        $stmt = $pdo->prepare("UPDATE categories SET image = NULL WHERE id = ?");
        $stmt->execute([$id]);
    }
    header("Location: select.php");
    exit;
}
?>
<!doctype html>
<html lang="en">
  <head>
    <title>Categories</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
  </head>
  <body>
    <div class="container mt-3">
        <a href="add.php" class="btn btn-primary mb-2">Add Category</a>
        <a href="select.php?delete_all=1" class="btn btn-danger mb-2" onclick="return confirm('Are you sure you want to delete ALL categories?')">Delete All</a>

        <table class="table table-bordered">
            <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Image</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <?php
                $query = $pdo->query("SELECT * FROM categories");
                $allCategories = $query->fetchAll(PDO::FETCH_ASSOC);
                foreach ($allCategories as $category) {
                ?>
                <tr>
                    <td><?php echo $category['id'] ?></td>
                    <td><?php echo htmlspecialchars($category['name']) ?></td>
                    <td><?php echo htmlspecialchars($category['description']) ?></td>
                    <td>
                        <?php if (!empty($category['image'])) { ?>
                            <img src="uploads/<?php echo htmlspecialchars($category['image']); ?>" width="100" height="80" alt="">
                            <br>
                            <a href="select.php?delete_file=<?php echo $category['id']; ?>" class="btn btn-warning btn-sm mt-1" onclick="return confirm('Delete this image file?')">Delete File</a>
                        <?php } else { echo "No Image"; } ?>
                    </td>
                    <td>
                        <a href="edit.php?id=<?php echo $category['id']; ?>" class="btn btn-success btn-sm">Edit</a>
                        <a href="select.php?delete_id=<?php echo $category['id']; ?>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this record?')">Delete</a>
                    </td>
                </tr>
                <?php } ?>
            </tbody>
        </table>
    </div>
  </body>
</html>
