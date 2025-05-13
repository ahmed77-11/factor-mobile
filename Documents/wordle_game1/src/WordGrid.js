import React from 'react';

function getLetterClass(letter, index, targetWord) {
    if (targetWord[index] === letter) return 'correct';
    if (targetWord.includes(letter)) return 'present';
    return 'absent';
}

const WordGrid = ({ guesses, currentGuess, target }) => {
    const rows = [];

    for (let i = 0; i < 6; i++) {
        const guess = guesses[i] || (i === guesses.length ? currentGuess : "");
        const isCurrent = i === guesses.length;
        const letters = guess.padEnd(5).split("");

        rows.push(
            <div className="row" key={i}>
                {letters.map((letter, j) => {
                    let className = "tile";
                    if (!isCurrent && guesses[i]) {
                        className += ` ${getLetterClass(letter, j, target)}`;
                    }
                    return (
                        <div key={j} className={className}>
                            {letter}
                        </div>
                    );
                })}
            </div>
        );
    }

    return <div className="grid">{rows}</div>;
};

export default WordGrid;
