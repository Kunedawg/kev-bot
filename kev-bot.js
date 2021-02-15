// imports
const gd = require('./globaldata.js');
const init = require('./init.js');
const event = require('./eventhandlers.js');
const {oncePerHour} = require("./functions/oncePerHour.js")
require('dotenv').config()

// Initialization
async function initialize(){
    console.log(await init.directories());
    console.log(await init.audio(process.argv[2] !== 'ndl'));
    console.log(await init.categories());
    console.log(await init.commands());
    await gd.client.login(process.env.BOT_TOKEN);
}
initialize().catch((err) => {
    console.error(err);
    console.error("Initialization failed! Exiting program!");
    process.exit(1);    // end program 
});

// Events
try {
    gd.client.once('ready', event.onReady);
    gd.client.on('voiceStateUpdate', (a,b) => {event.onVoiceStateUpdate(a,b)});
    gd.client.on('message', (message) => {event.onMessage(message,process.env.COMMAND_PREFIX)});
    setInterval(oncePerHour, 1000*60*60);  // once per hour updates
} catch(err) {
    console.error(err);
}