import React, { useState } from 'react';
import WordGrid from './WordGrid';
import Keyboard from './Keyboard';
import './App.css';


const aiesecWords = [
  "Youth", "Chair", "Leady", "Train", "Globe",
  "Serve", "Unite", "Teamy", "Growy", "Dream",
  "Peace", "Drive", "Adapt", "Align","IROGV",
];

const TARGET_WORD = aiesecWords[Math.floor(Math.random() * aiesecWords.length)].toUpperCase();

function App() {
  const [guesses, setGuesses] = useState([]);
  const [currentGuess, setCurrentGuess] = useState("");
  const [isGameOver, setIsGameOver] = useState(false);

  const handleKey = (key) => {
    if (isGameOver) return;

    if (key === 'ENTER') {
      if (currentGuess.length === 5) {
        const newGuesses = [...guesses, currentGuess];
        setGuesses(newGuesses);
        setCurrentGuess('');
        if (currentGuess === TARGET_WORD || newGuesses.length === 6) {
          setIsGameOver(true);
        }
      }
    } else if (key === 'DEL') {
      setCurrentGuess(currentGuess.slice(0, -1));
    } else if (/^[A-Z]$/.test(key) && currentGuess.length < 5) {
      setCurrentGuess(currentGuess + key);
    }
  };

  return (
      <div className="App">
        <h1 className="title">Wordle</h1>
        <WordGrid guesses={guesses} currentGuess={currentGuess} target={TARGET_WORD} />
        <Keyboard onKeyPress={handleKey} usedKeys={guesses} target={TARGET_WORD} />
        {isGameOver && (
            <div className="result">
              {guesses[guesses.length - 1] === TARGET_WORD ? "🎉 You win!" : `💥 Game Over! Word was ${TARGET_WORD}`}
            </div>
        )}
      </div>
  );
}

export default App;
