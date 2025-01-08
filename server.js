const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const PORT = 3000;

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Handle Slack Slash Command (e.g., /roll or /draw)
app.post('/slack/commands', (req, res) => {
    const commandText = req.body.command;
    let responseText = '';

    if (commandText.startsWith('/roll')) {
        const roll = Math.floor(Math.random() * 6) + 1;
        responseText = `🎲 You rolled a ${roll}! 🎉`;
    } else if (commandText.startsWith('/draw')) {
        const suits = ["Hearts", "Diamonds", "Clubs", "Spades"];
        const ranks = ["Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"];
        const suit = suits[Math.floor(Math.random() * suits.length)];
        const rank = ranks[Math.floor(Math.random() * ranks.length)];
        responseText = `🃏 You drew the ${rank} of ${suit}! 🎉`;
    } else {
        responseText = "Unknown command. Try `/roll` or `/draw`.";
    }

    // Respond to Slack with the result
    res.json({
        response_type: 'in_channel',
        text: responseText,
    });
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
