document.addEventListener('DOMContentLoaded', () => {
    const folderList = document.getElementById('folderList');
    const imageContainer = document.getElementById('imageContainer');

    function loadFolders() {
        fetch('/api/folders')
            .then(response => response.json())
            .then(folders => {
                folderList.innerHTML = '';
                folders.forEach(folder => {
                    let li = document.createElement('li');
                    li.textContent = folder;
                    li.addEventListener('click', () => loadImages(folder));
                    folderList.appendChild(li);
                });
            });
    }

    function loadImages(folderName) {
        fetch(`/api/folders/${folderName}/images`)
            .then(response => response.json())
            .then(images => {
                imageContainer.innerHTML = '';
                images.forEach(image => {                                   
                    let img = document.createElement('img');
                    img.src = `/images/${folderName}/${image}`;
                    imageContainer.appendChild(img);
                });
            });
    }

    setInterval(loadFolders, 5000); // Poll every 5 seconds

    loadFolders(); // Initial load
});
