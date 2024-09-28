module.exports = {
  PORT: process.env.PORT || 3000,
  ADDRESS: process.env.ADDRESS || "0.0.0.0",
  GCP_API_ENDPOINT: process.env.GCP_API_ENDPOINT,
  maxFileSize: 3000000, // bytes
  maxTrackNameLength: 15, // characters
  maxUsernameLength: 32, //characters
  minPasswordLength: 8, // characters
  maxPasswordLength: 64, // characters
  maxTrackDuration: 15.0, // seconds
  supportedTrackExtensions: [".mp3"],
  jwtTokenExpirationTime: "1h",
};
