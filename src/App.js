import { useCallback, useEffect , useState } from "react"
import Web3 from "web3";
import { loadContract } from "./utils/load-contract";
import detectEthereumProvider from '@metamask/detect-provider'
export default function App() {
  const [web3Api, setWeb3Api] = useState({
    provider: null,
    isProviderLoaded:false,
    web3: null,
    contract:null
  })
  const [account , setAccount] = useState(null);
  const [balance , setBalance] = useState(null);
  const canConnectToContract = account && web3Api.contract

  const setAccountListener = provider => {
    provider.on("accountsChanged", () => window.location.reload())
    provider.on("chainChanged", _ => window.location.reload())
  }
 
  useEffect(() => {
    const loadProvider = async () => {
      const provider = await detectEthereumProvider()
      if(provider) {
        const contract = await loadContract("Faucet" , provider);
        setAccountListener(provider)
        setWeb3Api({
          web3: new Web3(provider),
          provider,
          contract,
          isProviderLoaded:true
        })
      } else {
        // setWeb3Api({...web3Api, isProviderLoaded: true})
        setWeb3Api((api) => ({...api , isProviderLoaded: true}))
        console.log("Please connect to Metamask!")
      }     
    }

    loadProvider()
  }, [])
  useEffect(() => {
    const { contract , web3 } = web3Api;
    const loadBalance = async () => {
      const balance = await web3.eth.getBalance(contract.address);
      setBalance(web3.utils.fromWei(balance , "ether"));
     }
     web3Api.web3 && loadBalance()
  },[web3Api.web3])
  useEffect(() => {
  const getAccount = async () => {
    const accounts = await web3Api.web3.eth.getAccounts()
    setAccount(accounts[0])
  }
  web3Api.web3 && getAccount()
  },[web3Api.web3])

  const addFunds = useCallback(async () => {
    const { contract, web3 } = web3Api
    await contract.addFunders({
      from: account,
      value: web3.utils.toWei("0.5", "ether")
    })
    window.location.reload();
  }, [web3Api, account])

  const withDraw = useCallback(async () => {
    const { contract, web3 } = web3Api
    const withDrawAmount = web3.utils.toWei("0.1", "ether")
    await contract.withDraw(withDrawAmount,{
      from: account
    })
    window.location.reload();
  }, [web3Api, account])
 

  return (
    <>
      <div className="faucet-wrapper mt-5 ml-5">
        <div className="faucet">
        { web3Api.isProviderLoaded ?
            <div className="is-flex is-align-items-center">
              <span>
                <strong className="mr-2">Account: </strong>
              </span>
                { account ?
                  <div>{account}</div> :
                  !web3Api.provider ?
                  <>
                    <div className="notification is-warning is-size-6 is-rounded">
                      Wallet is not detected!{` `}
                      <a
                        rel="noreferrer"
                        target="_blank"
                        href="https://docs.metamask.io">
                        Install Metamask
                      </a>
                    </div>
                  </> :
                  <button
                    className="button is-small"
                    onClick={() =>
                      web3Api.provider.request({method: "eth_requestAccounts"}
                    )}
                  >
                    Connect Wallet
                  </button>
                }
            </div> :
            <span>Looking for Web3...</span>
          }
          <div className="balance-view is-size-2 my-4">
            Current Balance: <strong>{balance}</strong> ETH
          </div>
          { !canConnectToContract &&
            <i className="is-block">
              Connect to Ganache
            </i>
          }
          <button
            disabled={!canConnectToContract}
            onClick={addFunds}
            className="button is-link mr-2">Donate 0.5 ETH</button>
          <button
          disabled={!canConnectToContract}
            onClick={withDraw}
            className="button is-primary">Withdraw</button>
        </div>
      </div>
    </>
  )
}