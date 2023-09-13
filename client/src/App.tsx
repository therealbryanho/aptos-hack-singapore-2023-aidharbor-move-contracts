import React from 'react';
import { useState, useEffect } from "react";
import { Provider, Network, Types, AptosClient } from "aptos";
import { Layout, Row, Col, Button, Spin } from "antd";
import { WalletSelector } from "@aptos-labs/wallet-adapter-ant-design";
import "@aptos-labs/wallet-adapter-ant-design/dist/index.css";
import { useWallet } from "@aptos-labs/wallet-adapter-react";

const provider = new Provider(Network.TESTNET);
const moduleAddress = "0x46237378154b23618ecabe046cf1832f536766eb095813c2b1265845e05d9adb";
const client = new AptosClient('https://fullnode.testnet.aptoslabs.com/v1');

function App() {
  const [transactionInProgress, setTransactionInProgress] = useState<boolean>(false);
  const { account, signAndSubmitTransaction } = useWallet();
  const [accountHasList, setAccountHasList] = useState<boolean>(false);
  const [totalAptRaised, setTotalAptRaised] = useState(null);
  const [resources, setResources] = React.useState<Types.MoveResource[]>([]);

  const fetchList = async () => {
  // if (!account) return [];    
    try {
      // const CharityDonationResource = await provider.getAccountResource(
      //   account.address,
      //   `${moduleAddress}::charity_donation::CharityDonation`
      // );
      // console.log("CharityDonationResource: "+CharityDonationResource);
        try {
          const data = await new AptosClient(
            'https://fullnode.testnet.aptoslabs.com'
          ).view({
            function: `${moduleAddress}::CharityDonation::get_charity_apt_raised`,
            type_arguments: [],
            arguments: ["0x32e5a9e28f5d6d74279ac50edd4b912b196ac8219a7c81037c12ac8fcdf16de4"],
          });
      
          if (data[0]) {
            console.log("Total Raised for this Charity alone data[0]:"+data[0]);
            console.log("Total Raised for this Charity alone data:"+data);
            return {
              success: true,
              status: 'COMPLETED',
            };
          }
      
          return {
            success: true,
            status: 'CHARITY_DONT_EXIST',
          };
        } catch (error) {
          console.log(error);
          return {
            success: false,
            status: 'ERROR',
          };
        }
      

      setAccountHasList(true);
    } catch (e: any) {
      setAccountHasList(false);
    }
   };

  useEffect(() => {
    setAccountHasList(true);
    const apiUrl = 'https://fullnode.testnet.aptoslabs.com/v1/accounts/46237378154b23618ecabe046cf1832f536766eb095813c2b1265845e05d9adb/resource/0x46237378154b23618ecabe046cf1832f536766eb095813c2b1265845e05d9adb::CharityDonation::Charities';
    fetch(apiUrl)
      .then(response => response.json())
      .then(data => {
        // Access the "total_apt_raised" value from the JSON response
        const totalAptRaisedValue = data.data.total_apt_raised;
        setTotalAptRaised(totalAptRaisedValue);
        console.log('totalAptRaisedValue: ', totalAptRaisedValue);
      })
      .catch(error => {
        console.error('Error fetching data:', error);
      });

    fetchList();
  }, [account?.address]);

  const donateNow = async () => {
    if (!account) return [];
    setTransactionInProgress(true);

    // build a transaction payload to be submited
    const payload = {
      type: "entry_function_payload",
      function: `${moduleAddress}::CharityDonation::donate_to_charity`,
      type_arguments: [],
      arguments: ["0x32e5a9e28f5d6d74279ac50edd4b912b196ac8219a7c81037c12ac8fcdf16de4","100"],
    };
    try {
      // sign and submit transaction to chain
      const response = await signAndSubmitTransaction(payload);
      // wait for transaction
      await provider.waitForTransaction(response.hash);
      setAccountHasList(true);
    } catch (error: any) {
      setAccountHasList(false);
    } finally {
      setTransactionInProgress(false);
    }
  };

  return (
    <>
      <Layout>
        <Row align="middle">
          <Col span={10} offset={2}>
            <h1>Our todolist</h1>
          </Col>
          <Col span={12} style={{ textAlign: "right", paddingRight: "200px" }}>
            <WalletSelector />
          </Col>
        </Row>
      </Layout>
      <Spin spinning={transactionInProgress}>
        <Row gutter={[0, 32]} style={{ marginTop: "2rem" }}>
          <Col span={8} offset={8}>
            <Button onClick={donateNow} block type="primary" style={{ height: "40px", backgroundColor: "#3f67ff" }}>
              Donate 100 octas
            </Button>
          </Col>
        </Row>
      </Spin>
    </>
  );
}

export default App;