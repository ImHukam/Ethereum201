const {expect} = require("chai");
const { ethers } = require("hardhat");

describe("Token" , function() {
   it("Deployment should assign total supply to owner", async function() {
      const [owner]= await ethers.getSigners();
      console.log("getSigners: ", owner.address);

      const Token= await ethers.getContractFactory("Token"); //instance contract
      const token= await Token.deploy(); // deployment

      const ownerbalance = await token.balanceOf(owner.address);
      console.log("ownerbalance", ownerbalance);
      expect(await token.totalSupply()).to.equal(ownerbalance);
   });

   it("Should transfer token between accounts" , async function() {
      const [owner,addr1,addr2]= await ethers.getSigners();

      const Token= await ethers.getContractFactory("Token"); 
      const token= await Token.deploy(); 
      const amount1= 100;
      const amount2= 20;

      //transfer from owner to addr1
      await token.transfer(addr1.address,amount1);

      expect(await token.balanceOf(addr1.address)).to.equal(amount1);

      //transfer from addr1 to addr2
      await token.connect(addr1).transfer(addr2.address, amount2);
      expect(await token.balanceOf(addr2.address)).to.equal(amount2);

      expect(await token.balanceOf(addr1.address)).to.equal(amount1 - amount2);
   });
});
