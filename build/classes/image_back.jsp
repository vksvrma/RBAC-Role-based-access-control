<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upload Image</title>
    <link rel="stylesheet" type="text/css" href="image_styles.css">
</head>
<body>
<div class="container">
    <h1>Uploaded Images</h1>
    <div class="image-gallery">
        <%
        String imagePath = application.getRealPath("/images/first");
        File imageDir = new File(imagePath);
        if (imageDir.exists() && imageDir.isDirectory()) {
            File[] listOfFiles = imageDir.listFiles();
            if (listOfFiles != null && listOfFiles.length > 0) {
                for (File file : listOfFiles) {
                    if (file.isFile()) {
                        String fileName = file.getName();
        %>
                        <div class="image-container">
                            <div class="image-item">
                                <img src="images/first<%= fileName %>" alt="<%= fileName %>" class="img">
                            </div>
                            <p class="image-name"><%= fileName %></p>
                        </div>
        <%
                    }
                }
            } else {
                out.println("<p>No images found in the directory</p>");
            }
        } else {
            out.println("<p>Image directory does not exist.</p>");
        }
        %>
    </div>
    <div class="popup">
        <span>&times;</span>
        <img src="" alt="">
    </div>
</div>

<script>
document.querySelectorAll('.image-item img').forEach(image => {
    image.onclick = () => {
        document.querySelector('.popup').style.display = 'block';
        document.querySelector('.popup img').src = image.getAttribute('src');
        document.querySelector('.popup img').alt = image.getAttribute('alt');
    };
});
document.querySelector('.popup span').onclick = () => {
    document.querySelector('.popup').style.display = 'none';
};
</script>
</body>
</html>
