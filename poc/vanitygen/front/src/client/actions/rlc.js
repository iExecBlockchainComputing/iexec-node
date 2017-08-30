/* global web3 */
import rlc from '../../build/contracts/RLC.json';
import { SET_RLC } from './redux';
import { getSmartContractAddressByJsonNetworks } from '../vanity/utils';

export const setRlc = payload => ({
  type: SET_RLC,
  payload,
});

export const setNewRlc = () => (dispatch) => {
  if (window.web3.eth.accounts[0]) {
    const rlcContract = web3.eth.contract(rlc.abi);
    //  ropsten is const rlcInstance = rlcContract.at('0x9978b9a251e2f1b306dde81830c7bc97c5e6e149');
    const rlcInstance = rlcContract.at(getSmartContractAddressByJsonNetworks(rlc.networks));
    rlcInstance.balanceOf(window.web3.eth.accounts[0], (err, result) => {
      if (err) console.log(err);
      else dispatch(setRlc(Number(window.web3.fromWei(result, 'nano'))));
    });
  }
};

export default setRlc;
