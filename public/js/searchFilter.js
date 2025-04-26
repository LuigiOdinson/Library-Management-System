// inserting value for the genreFilterInput hidden input tag

const genreButtons = document.querySelectorAll('.filter-tag')
const genreFilterInput = document.getElementById('genreFilterInput')

let genres = []
genreButtons.forEach(button => {
    button.addEventListener('click', () => {
        const btnData = button.dataset.genre
        genreFilterInput.value = (btnData == 'No-Filter') ? '' : btnData
    })
})
