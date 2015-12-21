import QtQuick 2.5
import ".."
import "widgets"

BlockDefinition {
	type: "event"

	defaultParams: [ "DISABLED", "DISABLED", "DISABLED", "DISABLED", "DISABLED", "DISABLED", "DISABLED" ]

	Component {
		id: editorComponent
		Item {
			id: block;

			width: 256
			height: 256

			property var buttons: []

			// Thymio body
			ThymioBody {}

			// sensor buttons
			Component.onCompleted: {
				// front sensors
				for (var i=0; i<5; ++i) {
					var offset = 2.0 - i;
					buttons.push(buttonComponent.createObject(block, {
						"x": 128 - 16 - 150*Math.sin(0.34906585*offset),
						"y": 172 - 16 - 150*Math.cos(0.34906585*offset),
						"rotation": -20*offset,
						"state": params[i]
					}));
				}
				ledComponent.createObject(block, { "x": 17-12, "y": 78-12, "associatedButton": buttons[0] });
				ledComponent.createObject(block, { "x": 54-12, "y": 43-12, "associatedButton": buttons[1] });
				ledComponent.createObject(block, { "x": 104-12, "y": 26-12, "associatedButton": buttons[2] });
				ledComponent.createObject(block, { "x": 152-12, "y": 26-12, "associatedButton": buttons[2] });
				ledComponent.createObject(block, { "x": 202-12, "y": 43-12, "associatedButton": buttons[3] });
				ledComponent.createObject(block, { "x": 239-12, "y": 78-12, "associatedButton": buttons[4] });

				// back sensors
				for (var i=0; i<2; ++i) {
					buttons.push(buttonComponent.createObject(block, {
						"x": 64 - 16 + i*128,
						"y": 234 - 16,
						"state": params[i+5]
					}));
				}
				ledComponent.createObject(block, { "x": 40-12, "y": 234-12, "associatedButton": buttons[5] });
				ledComponent.createObject(block, { "x": 216-12, "y": 234-12, "associatedButton": buttons[6] });
			}

			function getParams() {
				return buttons.map(function(button) { return button.state; });
			}
		}
	}

	editor: Component {
		Loader {
			sourceComponent: editorComponent
			scale: 0.7
			property var params: defaultParams
			function getParams() { return item.getParams(); }
		}
	}

	miniature: Component {
		Loader {
			sourceComponent: editorComponent
			scale: 0.6
			property var params: defaultParams
		}
	}

	function compile(params) {
		return {
			event: "prox",
			condition: params.reduce(function(source, param, index) {
				if (param === "DISABLED") {
					return source;
				}
				source += " and prox.horizontal[" + index + "] "
				if (param === "CLOSE") {
					source += "> 2000";
				} else {
					source += "< 1000";
				}
				return source;
			}, "0 == 0"),
		};
	}

	Component {
		id: buttonComponent
		InfraredButton {}
	}
	Component {
		id: ledComponent
		InfraredLed {}
	}
}
