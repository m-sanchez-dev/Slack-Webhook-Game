# Standup Games

This is a simple Node.js server that handles Slack Slash Commands to play games like rolling a dice or drawing a card.

## Prerequisites

- Node.js
- npm
- Ngrok

## Installation

1. Clone the repository:

   ```sh
   git clone <repository-url>
   ```

2. Navigate to the project directory:

   ```sh
   cd standup-games
   ```

3. Install the dependencies:

   ```sh
   npm install
   ```

## Installing Ngrok on macOS

To install Ngrok on macOS, use Homebrew:

```sh
brew install ngrok
```

## Usage

1. Start the server:
   ```sh
   npm run start
   ```
2. Start Ngrok to tunnel your local server:
   ```sh
   npm run tunel
   ```
3. Alternatively, you can start both the server and Ngrok concurrently:

   ```sh
   npm run start-with-tunel
   ```

4. Configure your Slack workspace to use the server for Slash Commands:
   - `/roll` to roll a dice.
   - `/draw` to draw a card.

## Endpoints

- `POST /slack/commands`: Handles Slack Slash Commands.

## Example Commands

- `/roll`: Rolls a dice and returns a random number between 1 and 6.
- `/draw`: Draws a random card from a standard deck.

## License

This project is licensed under the MIT License.
