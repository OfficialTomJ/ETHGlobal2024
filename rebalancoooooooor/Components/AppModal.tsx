import { useEffect, useState } from "react";
import Head from "next/head";
import Popup from "./Popup"; // Import Popup component
import { useAccount, useEnsName } from "wagmi";

import { useReadContract } from "wagmi";
import { abi } from "../abi/abi";

export default function AppModal() {
  const [showPopup, setShowPopup] = useState(false);
  const [walletPools, setWalletPools] = useState([]);
  const account = useAccount();

  const result = useReadContract({
    abi,
    address: "0xb012F5B6Ed5879e94b6f83a021dA2b1088969777",
    functionName: "smartPoolCount",
  }).data;

  const handleCreatePool = () => {
    setShowPopup(true);
  };

  const handleClosePopup = () => {
    setShowPopup(false);
  };

    
  useEffect(() => {
    if (account.address) {
      console.log(result);
    }
  }, [account.address]);
  

  return (
    <div className="container">
      <Head>
        <title>No Pools Found - Rebalancoooooooor</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main>
        <h1 className="title">No Pools Found</h1>

        <button className="create-pool-button" onClick={handleCreatePool}>
          Create a Pool
        </button>

        {/* Render Popup component if showPopup is true */}
        {showPopup && <Popup onClose={handleClosePopup} />}
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
