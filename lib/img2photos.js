#!/usr/bin/osascript -l JavaScript

function run(argv) {
    try {
	var app = new Application("Photos");
	app.import(argv.map(Path));
    } catch(e) {
	console.log(e);
    }
}
