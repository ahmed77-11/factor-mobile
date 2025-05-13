import React from 'react';

const KEYS = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'DEL']
];

const Keyboard = ({ onKeyPress }) => {
    return (
        <div className="keyboard">
            {KEYS.map((row, i) => (
                <div key={i} className="keyboard-row">
                    {row.map((key) => (
                        <button key={key} onClick={() => onKeyPress(key)} className="key">
                            {key}
                        </button>
                    ))}
                </div>
            ))}
        </div>
    );
};

export default Keyboard;
