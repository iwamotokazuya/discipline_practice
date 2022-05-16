document.addEventListener('DOMContentLoaded', () => {
  const ImageList = document.getElementById('new-image');

  const createImageHTML = (blob) => {
    const imageElement = document.createElement('div');
    imageElement.setAttribute('class', "image-element")
    let imageElementNum = document.querySelectorAll('.image-element').length

    const blobImage = document.createElement('img');
    blobImage.setAttribute('class', 'new-img')
    blobImage.setAttribute('src', blob);

    const inputHTML = document.createElement('input');
    inputHTML.setAttribute('id', `recipe_image_${imageElementNum}`);
    inputHTML.setAttribute('class', 'recipe-images');
    inputHTML.setAttribute('name', 'recipe[images][]');
    inputHTML.setAttribute('type', 'file');

    imageElement.appendChild(blobImage);
    
    if (imageElementNum < 2) {
      imageElement.appendChild(inputHTML);
    }
    
    ImageList.appendChild(imageElement);

    inputHTML.addEventListener('change', (e) => {
      const file = e.target.files[0];
      const blob = window.URL.createObjectURL(file);
      createImageHTML(blob);
    });
  };

  document.getElementById('user_images').addEventListener('change', (e) => {

    const file = e.target.files[0];
    const blob = window.URL.createObjectURL(file);
    createImageHTML(blob);
  });
});