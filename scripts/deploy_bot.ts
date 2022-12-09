import '@nomiclabs/hardhat-ethers'
import { ethers } from 'hardhat'

async function main() {
  const factory = await ethers.getContractFactory('CryptoGiveaway')

  // If we had constructor arguments, they would be passed into deploy()
  const contract = await factory.deploy()

  // The address the Contract WILL have once mined
  console.log("CryptoGiveaway",contract.address)

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
