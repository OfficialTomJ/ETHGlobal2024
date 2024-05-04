export default function Popup({ onClose }) {
  return (
    <div className="popup createPool">
      <div className="popup-content">
        <span className="close" onClick={onClose}>
          <p className="close-icon">x</p>
        </span>
        <h2>Create Pool</h2>
        <div className="input-container">
          <input
            type="text"
            placeholder="Pool Name"
            className="pool-name-input"
          />
          <button className="create-pool-button">Create Pool</button>
        </div>
      </div>

      <style jsx>{`
        .popup {
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background-color: rgba(0, 0, 0, 0.5);
          display: flex;
          justify-content: center;
          align-items: center;
          z-index: 999;
        }

        .popup-content {
          position: relative;
          background-color: white;
          padding: 2rem;
          border-radius: 10px;
          box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
        }

        .close {
          position: absolute;
          top: 0;
          right: 0;
          cursor: pointer;
          padding: 0.5rem;
        }

        .close-icon {
          margin: 0;
        }

        .input-container {
          display: flex;
          flex-direction: column;
          gap: 1rem;
        }

        .pool-name-input {
          padding: 0.5rem;
          border: 1px solid #ccc;
          border-radius: 5px;
          font-size: 1rem;
        }

        .create-pool-button {
          padding: 0.5rem 1rem;
          font-size: 1rem;
          border-radius: 5px;
          background-color: #0070f3;
          color: white;
          border: none;
          cursor: pointer;
          transition: background-color 0.3s ease;
        }

        .create-pool-button:hover {
          background-color: #0056b3;
        }
      `}</style>
    </div>
  );
}
