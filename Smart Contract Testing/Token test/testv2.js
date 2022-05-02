const { inputToConfig } = require("@ethereum-waffle/compiler");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Token Contract", function () {
   let Token;
   let token;
   let owner;
   let addr1;
   let addr2;
   let addrs;

   beforeEach(async function () {
      Token = await ethers.getContractFactory("Token"); //instance contract
      token = await Token.deploy(); // deployment
      [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
   });

   describe("Deployment", function () {
      it("Should set right owner", async function () {
         expect(await token.owner()).to.equal(owner.address);
      });

      it("Should assign totalsupply to owner address", async function () {
         expect(await token.totalSupply()).to.equal(await token.balanceOf(owner.address));
      })
   });

   describe("Transactions", function () {
      it("Should transfer tokens between accounts", async function () {
         const amount = 100;
         await token.transfer(addr1.address, amount);
         expect(await token.balanceOf(addr1.address)).to.equal(amount);

         //transfer addr1 to addr2
         await token.connect(addr1).transfer(addr2.address, 30);
         expect(await token.balanceOf(addr2.address)).to.equal(30);
      });

      it("Should fail if sender does not have enough tokens", async function () {
         const ownerbalance= await token.balanceOf(owner.address);
         await expect(token.connect(addr1).transfer(owner.address, 10)).to.be.revertedWith("balance not sufficient");
         expect(await token.balanceOf(owner.address)).to.equal(ownerbalance);
      });

      it("Should update balances after transfer", async function(){
         const ownerbalance= await token.balanceOf(owner.address);
         await token.transfer(addr1.address,5);
         await token.transfer(addr2.address,10);

         expect(await token.balanceOf(owner.address)).to.equal(ownerbalance-15);
         expect(await token.balanceOf(addr1.address)).to.equal(5);
         expect(await token.balanceOf(addr2.address)).to.equal(10);
      });
   });
});
