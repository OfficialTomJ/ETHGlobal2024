import { ConnectButton } from '@rainbow-me/rainbowkit';
import type { NextPage } from 'next';
import Head from 'next/head';
import styles from '../styles/Home.module.css';
import AppModal from '../Components/AppModal';

const Home: NextPage = () => {
  return (
    <div className={styles.container}>
      <Head>
        <title>⚖️ Rebalancoooooooor</title>
        <meta
          content="Smart contract rebalacing dApp"
          name="description"
        />
        <link href="/favicon.ico" rel="icon" />
      </Head>

      <main className={styles.main}>
        <ConnectButton />

        <AppModal/>
      </main>

      <footer className={styles.footer}>
        <a href="https://rainbow.me" rel="noopener noreferrer" target="_blank">
          Made with ❤️ at ETHGlobal Sydney 2024
        </a>
      </footer>
    </div>
  );
};

export default Home;
