/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require("@nomiclabs/hardhat-waffle");

const INFURA_PROJECT_ID = "8bc3f35e295a4c218895a5d1ee14cf52";
const ROPSTEN_PRIVATE_KEY = "0fc33885b6ff55ea917085d828ab3316ac9c3e7c228d43ae3f410d8797328d54"
// module.exports = {
//   solidity: "0.7.3",
//   settings: {
//     optimizer: {
//       enabled: true,
//       runs: 1000
//     }
//   }
// };

module.exports = {
  solidity: "0.7.3",
  networks: {
    goerli: {
      url: "https://goerli.infura.io/v3/8bc3f35e295a4c218895a5d1ee14cf52",
      accounts: [`0x${ROPSTEN_PRIVATE_KEY}`],
    },
  },
};