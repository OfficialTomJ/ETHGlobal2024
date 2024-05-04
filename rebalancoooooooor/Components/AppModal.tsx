import { useEffect, useState } from "react";
import Head from "next/head";
import PoolPopup from "./CreatePoolPopup";
import { useAccount, useDisconnect, useEnsName } from "wagmi";
import { FiCheckCircle } from "react-icons/fi";

import { useReadContract } from "wagmi";
import { abi } from "../abi/abi";
import ConfigPopup from "./SubscribeToPoolPopup";

export default function AppModal() {
  const [showPoolPopup, setShowPoolPopup] = useState(false);
  const [showConfigPopup, setShowConfigPopup] = useState(false);
  const [walletPools, setWalletPools] = useState([
    {
      name: "Pool 1",
      address: "0xb012f5b6ed5879e94b6f83a021da2b1088969777",
    },
  ]);
  const [poolCounter, setPoolCounter] = useState(0);
  const account = useAccount();

  const result = useReadContract({
    abi,
    address: "0xb012F5B6Ed5879e94b6f83a021dA2b1088969777",
    functionName: "smartPoolCount",
    args: [account.address],
  });

  const handleOpenPoolPopup = () => {
    setShowPoolPopup(true);
  };

  const handleClosePoolPopup = () => {
    setShowPoolPopup(false);
  };

  const handleOpenConfigPopup = () => {
    setShowConfigPopup(true);
  };

  const handleCloseConfigPopup = () => {
    setShowConfigPopup(false);
  };

    
  useEffect(() => {
    console.log(account.address, result);

    if (result.data !== undefined) {
      const parsedPoolCounter = parseInt(result.data.toString());
      setPoolCounter(parsedPoolCounter);
    }
  }, [account.address, result]);

  useEffect(() => {
    //Fetch all pools and the address
    
  }, [poolCounter]);

  return (
    <div className="container">
      <Head>
        <title>No Pools Found - Rebalancoooooooor</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main>
        {poolCounter === 0 ? (
          <h1 className="title">
            {account.address
              ? "No Pools Found"
              : "Connect your wallet to use Rebalancoooooooor ⚖️"}
          </h1>
        ) : (
          <div className="pool-grid">
            {/* Render grid of available pools */}
            {walletPools.map((pool, index) => (
              <div className="pool" key={index} onClick={handleOpenConfigPopup}>
                {/* Add icon and heading for each pool */}
                <FiCheckCircle className="icon" />
                <h2>{pool.name}</h2>
                <h3>{pool.address}</h3>
              </div>
            ))}
          </div>
        )}

        {account.address && (
          <button className="create-pool-button" onClick={handleOpenPoolPopup}>
            Create a Pool
          </button>
        )}

        {/* Render Popup component if showPopup is true */}
        {showPoolPopup && <PoolPopup onClose={handleClosePoolPopup} />}
        {showConfigPopup && <ConfigPopup onClose={handleCloseConfigPopup} />}
      </main>

      <footer>
        <p>Powered by Uniswap</p>
      </footer>

      <style jsx>{`
        .container {
          min-height: 100vh;
          padding: 0 0.5rem;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
        }

        main {
          padding: 5rem 0;
          flex: 1;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
        }

        footer {
          width: 100%;
          height: 100px;
          border-top: 1px solid #eaeaea;
          display: flex;
          justify-content: center;
          align-items: center;
        }

        footer p {
          margin: 0;
        }

        .title {
          font-size: 2rem;
          margin-bottom: 1rem;
        }

        .pool {
          display: flex;
          flex-direction: column;
          align-items: center;
          border: 1px solid black;
          padding: 10px;
        }

        .create-pool-button {
          padding: 0.5rem 1rem;
          font-size: 1rem;
          border-radius: 5px;
          background-color: #0070f3;
          color: white;
          border: none;
          cursor: pointer;
        }

        .create-pool-button:hover {
          background-color: #0056b3;
        }
      `}</style>
    </div>
  );
}
