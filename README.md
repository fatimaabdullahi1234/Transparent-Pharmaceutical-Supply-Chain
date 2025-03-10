# Transparent Pharmaceutical Supply Chain

## Overview

This blockchain-based platform transforms pharmaceutical supply chain management by creating an immutable, transparent record of medications from manufacture to patient. By leveraging smart contracts, we enable all stakeholders to verify drug authenticity, maintain quality standards, ensure proper handling conditions, and respond rapidly to safety issues—ultimately enhancing patient safety and regulatory compliance while reducing counterfeiting and waste.

## Smart Contracts

### 1. Drug Registration Contract

Tracks medications through each stage of the supply chain, from raw materials to distribution.

**Key Features:**
- Unique digital identity for each drug batch and unit
- Manufacturing data recording (ingredients, processes, facilities)
- Batch and lot tracking with timestamps
- Chain of custody verification
- Serialization and anti-counterfeiting measures
- Regulatory approval documentation
- Expiration date management
- Digital signature verification for handoffs
- Packaging authenticity validation
- GS1 standard compliance for universal identification

### 2. Quality Control Contract

Manages and verifies drug testing procedures and results throughout the manufacturing and distribution process.

**Key Features:**
- Laboratory test result verification and storage
- Quality assurance checkpoint documentation
- Stability testing protocols and results
- Release certification management
- Impurity and contaminant testing
- Statistical quality control metrics
- Audit trail for quality procedures
- Third-party lab verification
- Regulatory compliance documentation
- Quality deviation tracking and resolution

### 3. Cold Chain Verification Contract

Ensures maintenance of proper temperature and environmental conditions during storage and transport of temperature-sensitive medications.

**Key Features:**
- Real-time temperature and humidity monitoring
- Condition breach alerts and documentation
- IoT sensor data integration and validation
- Transport condition visualization
- Temperature excursion management
- Container qualification verification
- Route risk assessment
- Handler certification verification
- Environmental stress analysis
- Last-mile condition verification

### 4. Recall Management Contract

Facilitates rapid, targeted recalls of compromised medications with complete traceability.

**Key Features:**
- Precision recall targeting to specific batches/units
- Automated stakeholder notification system
- Recall status tracking and verification
- Return and destruction documentation
- Root cause analysis documentation
- Regulatory reporting automation
- Patient notification management
- Replacement processing
- Financial reconciliation for recalled products
- Recall effectiveness metrics

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     User Interfaces                          │
│  (Manufacturer, Distributor, Pharmacy, Regulator, Patient)   │
└───────────────────────────┬─────────────────────────────────┘
                            │
┌───────────────────────────┼─────────────────────────────────┐
│                     Blockchain Layer                         │
├────────────┬───────────────┬────────────────┬───────────────┤
│    Drug    │    Quality    │   Cold Chain   │    Recall     │
│Registration│    Control    │  Verification  │  Management   │
│  Contract  │   Contract    │    Contract    │   Contract    │
└────────────┴───────────────┴────────────────┴───────────────┘
                            │
┌───────────────────────────┼─────────────────────────────────┐
│                    Integration Layer                         │
│   (ERP Systems, LIMS, WMS, IoT Devices, Regulatory APIs)     │
└───────────────────────────┬─────────────────────────────────┘
                            │
┌───────────────────────────┼─────────────────────────────────┐
│                    Physical Layer                            │
│ (Manufacturing, Distribution Centers, Transport, Pharmacies) │
└─────────────────────────────────────────────────────────────┘
```

## Getting Started

### Prerequisites
- Node.js (v16+)
- Solidity compiler (v0.8+)
- Truffle or Hardhat development environment
- Ethereum-compatible blockchain (private or public)
- IoT gateway for cold chain monitoring
- GS1 barcode/RFID scanning capability
- Integration adapters for enterprise systems

### Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/pharma-supply-chain.git
   cd pharma-supply-chain
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Compile smart contracts:
   ```
   npx truffle compile
   ```
   or
   ```
   npx hardhat compile
   ```

4. Deploy to your chosen network:
   ```
   npx truffle migrate --network <network_name>
   ```
   or
   ```
   npx hardhat run scripts/deploy.js --network <network_name>
   ```

5. Configure system integrations:
   ```
   node scripts/configure-integrations.js
   ```

## Usage Examples

### Manufacturer
```javascript
// Register a new drug batch
await drugContract.registerBatch(
  "AMOX-2023-07B",
  {
    drugName: "Amoxicillin",
    strength: "500mg",
    dosageForm: "capsule",
    quantity: 100000,
    manufacturingDate: 1627776000, // Unix timestamp
    expiryDate: 1690848000, // Unix timestamp
    manufacturingFacility: "Facility-A",
    regulatoryApprovals: ["FDA-12345", "EMA-54321"]
  },
  {from: manufacturerAddress}
);

// Record quality control results
await qualityContract.recordTestResults(
  "AMOX-2023-07B",
  {
    assayResult: 99.7,
    dissolutionResult: 98.5,
    impurityLevels: {
      "Impurity A": 0.05,
      "Impurity B": 0.03
    },
    microbiologicalResults: "PASS",
    testingFacility: "QC-Lab-1",
    testingDate: Date.now(),
    approvedBy: "0x742d35Cc6634C0532925a3b844Bc454e4438f44e"
  },
  {from: qcLabAddress}
);
```

### Distributor
```javascript
// Record shipment with cold chain data
await coldChainContract.initiateShipment(
  "SHIP-2023-10-15",
  {
    batchIds: ["AMOX-2023-07B"],
    origin: "Manufacturer-A-Warehouse",
    destination: "Distributor-B-Facility",
    transportMethod: "refrigerated-truck",
    storageConditions: {
      minTemp: 2, // Celsius
      maxTemp: 8, // Celsius
      minHumidity: 30, // percentage
      maxHumidity: 60 // percentage
    },
    estimatedArrival: 1634515200, // Unix timestamp
    sensorIds: ["SENSOR-452", "SENSOR-453"]
  },
  {from: distributorAddress}
);

// Record temperature readings from IoT sensors
await coldChainContract.recordEnvironmentalData(
  "SHIP-2023-10-15",
  {
    sensorId: "SENSOR-452",
    readings: [
      {timestamp: 1634428800, temperature: 5.2, humidity: 45},
      {timestamp: 1634432400, temperature: 5.1, humidity: 46},
      {timestamp: 1634436000, temperature: 5.3, humidity: 44}
    ]
  },
  {from: iotGatewayAddress}
);
```

### Regulator
```javascript
// Initiate a product recall
await recallContract.initiateRecall(
  "RECALL-2023-11",
  {
    batchIds: ["AMOX-2023-07B"],
    recallLevel: 2, // 1=pharmacy, 2=wholesale, 3=consumer
    reason: "Dissolution failure in stability testing",
    instructions: "Quarantine product and return to manufacturer",
    regulatoryReferenceNumber: "FDA-RECALL-2023-42",
    contactInformation: "recall@manufacturer.com",
    effectiveDate: Date.now()
  },
  {from: regulatorAddress}
);
```

### Pharmacy
```javascript
// Verify product authenticity and recall status
const verificationResult = await drugContract.verifyProduct(
  "AMOX-2023-07B-UNIT-54321", // Serial number
  {from: pharmacyAddress}
);

// Acknowledge receipt of recall notice
await recallContract.acknowledgeRecall(
  "RECALL-2023-11",
  {
    facilityId: "PHARM-1234",
    quantityInInventory: 250,
    quarantineLocation: "Recall Shelf B",
    returnTrackingInfo: "RA-89878767"
  },
  {from: pharmacyAddress}
);
```

## Compliance and Regulatory Features

The platform is designed to meet global pharmaceutical regulations:
- FDA DSCSA (Drug Supply Chain Security Act)
- EU Falsified Medicines Directive (FMD)
- GMP (Good Manufacturing Practice) documentation
- GDP (Good Distribution Practice) requirements
- Pharmacopeia standards compliance
- Global harmonization initiatives (ICH, PIC/S)

## Security and Privacy

- Zero-knowledge proofs for competitive information protection
- Role-based access controls for sensitive data
- Private transactions for confidential business information
- HIPAA-compliant patient data handling
- Regulatory authority special access provisions
- Granular permissioning systems
- Regular security audits

## Contributing

We welcome contributions to improve the Transparent Pharmaceutical Supply Chain platform:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- World Health Organization (WHO)
- U.S. Food and Drug Administration (FDA)
- European Medicines Agency (EMA)
- Pharmaceutical Supply Chain Initiative (PSCI)
- GS1 Global Standards Organization
