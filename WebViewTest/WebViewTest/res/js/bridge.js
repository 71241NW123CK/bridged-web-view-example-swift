
function acceptBridgeObjectPayloadJsonWithHandler(bridgeObjectPayloadJson, bridgeObjectHandler) {
  let bridgeObjectPayload = JSON.parse(bridgeObjectPayloadJson);
  let bridgeObjects = bridgeObjectPayload.bridgeObjects;
  bridgeObjects.forEach(bridgeObjectHandler);
}

function sendBridgeObjects(bridgeObjects) {
  let bridgeObjectPayload = {bridgeObjects: bridgeObjects};
  let bridgeObjectPayloadJson = JSON.stringify(bridgeObjectPayload);
  console.log(bridgeObjectPayloadJson);
}
