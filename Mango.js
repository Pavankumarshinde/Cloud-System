// MongoDB Cheat Sheet

// 1. Basic Commands
show dbs;                       // Show all databases
use database_name;              // Switch to a specific database
show collections;               // Show all collections in the current database

// 2. Insert Operations
db.collection_name.insertOne({ key: "value", key2: "value2" }); // Insert a single document
db.collection_name.insertMany([                                // Insert multiple documents
    { key: "value1", key2: "value2" },
    { key: "value3", key2: "value4" }
]);

// 3. Query Operations
db.collection_name.find();                                     // Find all documents
db.collection_name.find({ key: "value" });                    // Find with query filter
db.collection_name.find({ key: "value" }, { key1: 1, key2: 1 }); // Include fields (projection)
db.collection_name.find({ key: "value" }, { key3: 0 });          // Exclude fields
db.collection_name.findOne({ key: "value" });                   // Find one document

// 4. Update Operations
db.collection_name.updateOne(
    { key: "value" },                // Query filter
    { $set: { key: "new_value" } }   // Update operation
);
db.collection_name.updateMany(
    { key: "value" },
    { $set: { key: "new_value" } }
);
db.collection_name.replaceOne(
    { key: "value" },               // Query filter
    { key1: "new_value1", key2: "new_value2" } // Replacement document
);

// 5. Delete Operations
db.collection_name.deleteOne({ key: "value" });  // Delete one document
db.collection_name.deleteMany({ key: "value" }); // Delete multiple documents

// 6. Index Operations
db.coll.createIndex({ name: 1 });                          // Create ascending index
db.coll.createIndex({ age: -1 }, { unique: true });        // Create descending & unique index
db.coll.getIndexes();                                      // List all indexes
db.coll.dropIndex("name_1");                                // Drop a specific index

// 7. Handy Commands
db.coll.countDocuments();                                  // Count documents in collection
db.currentOp();                                            // View ongoing operations
db.killOp(<opid>);                                         // Terminate an operation
db.serverStatus();                                         // View server health & metrics

// 8. Change Streams
watchCursor = db.coll.watch();                            // Create change stream
while (!watchCursor.isExhausted()) {
    if (watchCursor.hasNext()) {
        printjson(watchCursor.next());                    // Print changes in real-time
    }
}

// 9. Replica Set Operations
rs.status();                                              // Check replica set status
rs.initiate();                                            // Initiate a replica set
rs.add("mongodb2.example.net:27017");                     // Add a node to the replica set
rs.stepDown();                                            // Force the primary to step down

// 10. Sharded Cluster Commands
sh.status();                                              // View shard cluster status
sh.addShard("rs1/mongodb1.example.net:27017");            // Add a shard
sh.shardCollection("mydb.orders", { orderId: 1 });        // Shard a collection
sh.moveChunk("mydb.orders", { orderId: 123 }, "shard002"); // Move a chunk to another shard

// 11. Text Search
db.movies.createIndex({ title: "text", plot: "text" });    // Create a text index
db.movies.find({ $text: { $search: "adventure thriller" } }); // Search using text index

// 12. Aggregation
db.collection_name.aggregate([
    { $match: { key: "value" } },                        // Match documents
    { $group: { _id: "$key", total: { $sum: 1 } } }      // Group and calculate total
]);

// 13. Sorting, Limiting, Skipping
db.collection_name.find().sort({ key: 1 });              // Sort ascending
db.collection_name.find().sort({ key: -1 });             // Sort descending
db.collection_name.find().limit(5);                      // Limit number of results
db.collection_name.find().skip(5);                       // Skip first n results

// 14. Drop Operations
db.collection_name.drop();                               // Drop a collection
db.dropDatabase();                                       // Drop the current database
