import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Lock", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployCrocPermitOracleFixture() {
    const [owner1, owner2, owner3, owner4, owner5] = await ethers.getSigners();

    const CrocPermitOracle = await ethers.getContractFactory(
      "CrocPermitOracle"
    );
    const crocPermitOracle = await CrocPermitOracle.deploy([
      owner1.address,
      owner2.address,
      owner3.address,
      owner4.address,
      owner5.address,
    ]);

    const signers = [
      owner1.address,
      owner2.address,
      owner3.address,
      owner4.address,
      owner5.address,
    ];

    return {
      owner1,
      owner2,
      owner3,
      owner4,
      owner5,
      signers,
      crocPermitOracle,
    };
  }

  describe("Deployment", function () {
    it("Should be same ownersHash", async function () {
      const { owner1, owner2, owner3, owner4, owner5, crocPermitOracle } =
        await loadFixture(deployCrocPermitOracleFixture);

      const zeros = "000000000000000000000000";
      const addressesAbiEncode =
        "0x" +
        zeros +
        owner1.address.substring(2) +
        zeros +
        owner2.address.substring(2) +
        zeros +
        owner3.address.substring(2) +
        zeros +
        owner4.address.substring(2) +
        zeros +
        owner5.address.substring(2);

      const ownersHash = await crocPermitOracle.connect(owner1).ownersHash();
      const ownerHashWithEthers = ethers.utils.keccak256(addressesAbiEncode);

      expect(ownersHash).to.be.equal(ownerHashWithEthers);
    });

    it("Should be same osdfdswnersHash", async function () {
      const { owner1, owner2, owner3, owner4, owner5, crocPermitOracle } =
        await loadFixture(deployCrocPermitOracleFixture);

      const zeros = "000000000000000000000000";
      const addressesAbiEncode =
        "0x" +
        zeros +
        owner1.address.substring(2) +
        zeros +
        owner2.address.substring(2) +
        zeros +
        owner3.address.substring(2) +
        zeros +
        owner4.address.substring(2) +
        zeros +
        owner5.address.substring(2);

      const ownersHash = await crocPermitOracle.connect(owner1).ownersHash();
      const ownerHashWithEthers = ethers.utils.keccak256(addressesAbiEncode);

      expect(ownersHash).to.be.equal(ownerHashWithEthers);
    });
  });

  describe("Signing", function () {
    it("Should sign the transaction", async function () {
      const {
        owner1,
        owner2,
        owner3,
        owner4,
        owner5,
        signers,
        crocPermitOracle,
      } = await loadFixture(deployCrocPermitOracleFixture);

      var vs = [];
      var rs = [];
      var ss = [];

      const dataToBeSigned = {
        types: {
          setAuth: [
            { name: "user", type: "address" },
            { name: "s", type: "bool" },
            { name: "m", type: "bool" },
            { name: "b", type: "bool" },
            { name: "i", type: "bool" },
          ],
        },
        primaryType: "setAuth",
        domain: {
          name: "CrocSwap",
          version: "1",
          chainId: 31337,
          verifyingContract: crocPermitOracle.address,
        },
        message: {
          user: "0x114B242D931B47D5cDcEe7AF065856f70ee278C4",
          s: true,
          m: true,
          b: true,
          i: true,
        },
      };

      var signature = await owner1._signTypedData(
        dataToBeSigned.domain,
        dataToBeSigned.types,
        dataToBeSigned.message
      );
      var { v, r, s } = ethers.utils.splitSignature(signature);
      vs.push(v);
      rs.push(r);
      ss.push(s);

      signature = await owner2._signTypedData(
        dataToBeSigned.domain,
        dataToBeSigned.types,
        dataToBeSigned.message
      );
      var { v, r, s } = ethers.utils.splitSignature(signature);
      vs.push(v);
      rs.push(r);
      ss.push(s);

      signature = await owner3._signTypedData(
        dataToBeSigned.domain,
        dataToBeSigned.types,
        dataToBeSigned.message
      );
      var { v, r, s } = ethers.utils.splitSignature(signature);
      vs.push(v);
      rs.push(r);
      ss.push(s);

      signature = await owner4._signTypedData(
        dataToBeSigned.domain,
        dataToBeSigned.types,
        dataToBeSigned.message
      );
      var { v, r, s } = ethers.utils.splitSignature(signature);
      vs.push(v);
      rs.push(r);
      ss.push(s);

      signature = await owner5._signTypedData(
        dataToBeSigned.domain,
        dataToBeSigned.types,
        dataToBeSigned.message
      );
      var { v, r, s } = ethers.utils.splitSignature(signature);
      vs.push(v);
      rs.push(r);
      ss.push(s);

      var auth = {
        s: true,
        m: true,
        b: true,
        i: true,
      };

      var xd = await crocPermitOracle
        .connect(owner1)
        .setAuth(
          "0x114B242D931B47D5cDcEe7AF065856f70ee278C4",
          auth,
          signers,
          vs,
          rs,
          ss
        );
      console.log(xd);
      var result = await crocPermitOracle.auths(
        "0x114B242D931B47D5cDcEe7AF065856f70ee278C4"
      );
      console.log(result);
    });

    it("Should sign batch transactions", async function () {
      const {
        owner1,
        owner2,
        owner3,
        owner4,
        owner5,
        signers,
        crocPermitOracle,
      } = await loadFixture(deployCrocPermitOracleFixture);

      var vs = [];
      var rs = [];
      var ss = [];

      const dataToBeSigned = {
        types: {
          setBatchAuth: [
            { name: "root", type: "bytes32" }
          ],
        },
        primaryType: "setBatchAuth",
        domain: {
          name: "CrocSwap",
          version: "1",
          chainId: 31337,
          verifyingContract: crocPermitOracle.address,
        },
        message: {
          root: "0x64dae981ca6f27a51acbce55511737d56ad44af76bbfb7197ea59da6b6506d60"
        },
      };

      var signature = await owner1._signTypedData(
        dataToBeSigned.domain,
        dataToBeSigned.types,
        dataToBeSigned.message
      );
      var { v, r, s } = ethers.utils.splitSignature(signature);
      vs.push(v);
      rs.push(r);
      ss.push(s);

      signature = await owner2._signTypedData(
        dataToBeSigned.domain,
        dataToBeSigned.types,
        dataToBeSigned.message
      );
      var { v, r, s } = ethers.utils.splitSignature(signature);
      vs.push(v);
      rs.push(r);
      ss.push(s);

      signature = await owner3._signTypedData(
        dataToBeSigned.domain,
        dataToBeSigned.types,
        dataToBeSigned.message
      );
      var { v, r, s } = ethers.utils.splitSignature(signature);
      vs.push(v);
      rs.push(r);
      ss.push(s);

      signature = await owner4._signTypedData(
        dataToBeSigned.domain,
        dataToBeSigned.types,
        dataToBeSigned.message
      );
      var { v, r, s } = ethers.utils.splitSignature(signature);
      vs.push(v);
      rs.push(r);
      ss.push(s);

      signature = await owner5._signTypedData(
        dataToBeSigned.domain,
        dataToBeSigned.types,
        dataToBeSigned.message
      );
      var { v, r, s } = ethers.utils.splitSignature(signature);
      vs.push(v);
      rs.push(r);
      ss.push(s);

      var auth = {
        s: true,
        m: true,
        b: true,
        i: true,
      };

      const abi = ethers.utils.defaultAbiCoder;
      const abiEncode = abi.encode(["uint256[]"],[[1,2]]);
      console.log(abiEncode)
      let batchAddresses = [
        "0x114B242D931B47D5cDcEe7AF065856f70ee278C4",
        "0x2F42323d90C29a53f8cC5ed2c85674E07fB252cd",
      ];
      let batchAuth = [true, true];

      var xd = await crocPermitOracle
        .connect(owner1)
        .batchAuth(
          ["0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"],
          [[true,true,true,true]],
          signers,
          vs,
          rs,
          ss
        );
        var result = await crocPermitOracle.auths(
          "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"
        );
        // console.log(result);
    });
  });
});
