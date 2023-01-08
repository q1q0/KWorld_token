import '@nomiclabs/hardhat-ethers'
import { ethers } from 'hardhat'

async function main() {
  const signers = await ethers.getSigners()
  console.log(await signers[0].getAddress())
  console.log(await signers[0].getChainId())
  console.log(await signers[0].getBalance())
  const factory = await ethers.getContractFactory('KWorld')

  // If we had constructor arguments, they would be passed into deploy()
  const contract = await factory.deploy("0x8Eef3f423310EC53B1D1d0d0f8f5fb48B3f9663D", "0x583177B38556bA4763F1B0f76B2D08e9F6B345d1", "0xb54Fb84E9F8EBD92a7881602f144A071bf3b9A60", "0x1434c08D115c4D4303117CFB403ed5DaEE06b96F")

  // The address the Contract WILL have once mined
  
  console.log("KWorld   ",contract.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
