import { useState } from "react";
import { FaBitcoin, FaEthereum, FaDollarSign } from "react-icons/fa";

export default function PopUp({ onClose }) {
  const [subscriptionAmounts, setSubscriptionAmounts] = useState({
    WBTC: 0,
    ETH: 0,
    DAI: 0,
  });
  const [poolName, setPoolName] = useState("");

  const handleInputChange = (asset, value) => {
    const total = Object.values(subscriptionAmounts).reduce(
      (acc, curr) => acc + parseFloat(curr),
      0
    );
    const remaining = 100 - total + parseFloat(subscriptionAmounts[asset]);
    const newValue = Math.min(value, remaining);
    setSubscriptionAmounts((prevState) => ({
      ...prevState,
      [asset]: newValue,
    }));
  };

  const total = Object.values(subscriptionAmounts).reduce(
    (acc, curr) => acc + parseFloat(curr),
    0
  );
  const isDisabled = total !== 100 || !poolName;

  const handleCreatePool = () => {

  }; 

  return (
    <div className="popup subscribePool">
      <div className="popup-content">
        <span className="close" onClick={onClose}>
          <p className="close-icon">x</p>
        </span>
        <h2>Create a New Pool</h2>
        <div className="pool-name">
          <h3>Pool Name</h3>
          <input
            type="text"
            placeholder="Enter pool name"
            value={poolName}
            onChange={(e) => setPoolName(e.target.value)}
          />
        </div>
        <div className="select-crypto">
          <h3>Select Cryptocurrencies</h3>
          <div className="asset-selection">
            <div className="asset">
              <FaBitcoin className="icon" />
              <span>WBTC</span>
              <input
                type="number"
                placeholder="Amount"
                value={subscriptionAmounts.WBTC}
                onChange={(e) => handleInputChange("WBTC", e.target.value)}
              />
              <input
                type="range"
                min={0}
                max={100}
                value={subscriptionAmounts.WBTC}
                onChange={(e) => handleInputChange("WBTC", e.target.value)}
              />
            </div>
            <div className="asset">
              <FaEthereum className="icon" />
              <span>ETH</span>
              <input
                type="number"
                placeholder="Amount"
                value={subscriptionAmounts.ETH}
                onChange={(e) => handleInputChange("ETH", e.target.value)}
              />
              <input
                type="range"
                min={0}
                max={100}
                value={subscriptionAmounts.ETH}
                onChange={(e) => handleInputChange("ETH", e.target.value)}
              />
            </div>
            <div className="asset">
              <FaDollarSign className="icon" />
              <span>DAI</span>
              <input
                type="number"
                placeholder="Amount"
                value={subscriptionAmounts.DAI}
                onChange={(e) => handleInputChange("DAI", e.target.value)}
              />
              <input
                type="range"
                min={0}
                max={100}
                value={subscriptionAmounts.DAI}
                onChange={(e) => handleInputChange("DAI", e.target.value)}
              />
            </div>
          </div>
        </div>
        <div className="rebalance-frequency">
          <h3>Rebalance Frequency</h3>
          <select>
            <option value="Daily">Daily</option>
            <option value="Weekly">Weekly</option>
            <option value="Monthly">Monthly</option>
          </select>
        </div>
        <button
          className="subscribe-button"
          onClick={handleCreatePool}
          disabled={isDisabled}
        >
          Create now
        </button>
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
          background-color: #0f1724;
          padding: 2rem;
          border-radius: 12px;
          box-shadow: 0px 0px 24px rgba(0, 0, 0, 0.2);
          width: 400px;
          color: #fff;
        }

        .close {
          position: absolute;
          top: 12px;
          right: 12px;
          cursor: pointer;
          color: #fff;
        }

        .close-icon {
          margin: 0;
          font-size: 1.2rem;
        }

        h2 {
          margin-top: 0;
          font-size: 1.5rem;
        }

        .select-crypto,
        .rebalance-frequency {
          margin-bottom: 1.5rem;
        }

        h3 {
          margin: 0 0 1rem;
          font-size: 1.2rem;
        }

        .asset-selection {
          display: flex;
          flex-direction: column;
          gap: 1rem;
        }

        .asset {
          display: flex;
          align-items: center;
          gap: 1rem;
        }

        .icon {
          font-size: 2rem;
          color: #fff;
        }

        input[type="number"] {
          padding: 0.5rem;
          border: none;
          background-color: #3a3f46;
          border-radius: 5px;
          color: #fff;
          width: 80px;
        }

        input[type="range"] {
          width: 100%;
          -webkit-appearance: none;
          height: 8px;
          border-radius: 5px;
          background: #3a3f46;
          outline: none;
          margin: 0;
          padding: 0;
        }

        input[type="range"]::-webkit-slider-thumb {
          -webkit-appearance: none;
          appearance: none;
          width: 16px;
          height: 16px;
          border-radius: 50%;
          background: #fff;
          cursor: pointer;
          border: 2px solid #0070f3;
        }

        select {
          width: 100%;
          padding: 0.5rem;
          border: none;
          background-color: #3a3f46;
          border-radius: 5px;
          color: #fff;
        }

        .subscribe-button {
          padding: 0.5rem 1rem;
          font-size: 1rem;
          border-radius: 5px;
          background-color: ${isDisabled ? "#6c757d" : "#0070f3"};
          color: white;
          border: none;
          cursor: ${isDisabled ? "not-allowed" : "pointer"};
          transition: background-color 0.3s ease;
          opacity: ${isDisabled ? "0.6" : "1"};
        }

        .withdraw-button {
          padding: 0.5rem 1rem;
          font-size: 1rem;
          border-radius: 5px;
          background-color: ${true ? "#6c757d" : "#0070f3"};
          color: white;
          border: none;
          cursor: ${true ? "not-allowed" : "pointer"};
          transition: background-color 0.3s ease;
          opacity: ${true ? "0.6" : "1"};
        }

        .subscribe-button:hover {
          background-color: ${isDisabled ? "#6c757d" : "#0056b3"};
        }
        .pool-name {
          margin-bottom: 1.5rem;
        }

        .pool-name h3 {
          margin: 0 0 0.5rem;
          font-size: 1.2rem;
        }

        .pool-name input[type="text"] {
          padding: 0.5rem;
          border: none;
          background-color: #3a3f46;
          border-radius: 5px;
          color: #fff;
          width: 100%;
        }
      `}</style>
    </div>
  );
}
