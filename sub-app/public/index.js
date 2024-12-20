console.log("HELLO WORLD");
if (document.getElementById('fetch-message')){
    console.log("It exists.")
    document.getElementById('fetch-message').addEventListener('click', function() {
        // Call the API when the button is clicked
        console.log("Clicked")
        fetch('http://3.15.6.49:3030/message') // Replace with your actual API endpoint
            .then(response => response.json()) // Assuming the response is in JSON format
            .then(data => {
            // Display the message in the <p> element with id="message"
            document.getElementById('message').textContent = data.message; // Assuming the response has a "message" property
            })
            .catch(error => {
            console.error('Error fetching message:', error);
            document.getElementById('message').textContent = 'Failed to load message';
            });
    });
}