<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File, java.net.URLEncoder, java.net.URLDecoder" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Image Viewer</title>
    <link rel="stylesheet" type="text/css" href="image_styles.css">
</head>
<body>
    <!-- Left Panel: Folders -->
    <div id="left-panel">
        <h2>Folders</h2>
        <%
            String basePath = application.getRealPath("/images");
            File dir = new File(basePath);
            File[] listOfFolders = dir.listFiles(File::isDirectory);

            if (listOfFolders != null) {
                for (File folder : listOfFolders) {
                    String folderName = folder.getName();
        %>
                    <div class="folder-item" onclick="loadImages('<%= URLEncoder.encode(folder.getAbsolutePath(), "UTF-8") %>')">
                        <%= folderName %>
                    </div>
        <%
                }
            } else {
                out.println("<p>No folders found.</p>");
            }
        %>
    </div>

    <!-- Right Panel: Images -->
    <div id="right-panel">
        <h2>Images</h2>
        <p>Select a folder to view images.</p>
    </div>

    <div class="popup">
        <span>&times;</span>
        <img src="" alt="">
    </div>

    <script>
        // Function to load images dynamically
       function loadImages(folderPath) {
    const xhr = new XMLHttpRequest();
    xhr.open('GET', 'viewDirectory.jsp?action=viewImages&path=' + encodeURIComponent(folderPath), true);
    xhr.onload = function () {
        if (xhr.status === 200) {
            document.getElementById('right-panel').innerHTML = xhr.responseText;
            setupPopup();  // Re-setup the popup functionality after loading new images
        } else {
            console.error('Failed to load images');
        }
    };
    xhr.send();
}


        // Function to set up popup functionality
        function setupPopup() {
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
        }
    </script>

<%
    String action = request.getParameter("action");

    if ("viewImages".equals(action)) {
        String path = request.getParameter("path");
        path = URLDecoder.decode(path, "UTF-8");

        File imageDir = new File(path);
        File[] listOfFiles = imageDir.listFiles((dir1, name) -> name.matches(".*\\.(jpg|jpeg|png|gif)$"));

        out.println("<div class='image-gallery'>");

        if (listOfFiles != null && listOfFiles.length > 0) {
            for (File file : listOfFiles) {
                String fileName = file.getName();
%>
                <div class="image-container">
                    <div class="image-item">
                       <img src="images/<%= new File(path).getName() %>/<%= fileName %>" alt="<%= fileName %>" class="img">
                    </div>
                    <p class="image-name"><%= fileName %></p>
                </div>
<%
            }
        } else {
            out.println("<p>No images found in the selected folder.</p>");
        }

        out.println("</div>");
        return;
    }
%>


</body>
</html>