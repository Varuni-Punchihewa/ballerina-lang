import React, { StatelessComponent } from "react";
import { Button, Icon, Menu } from "semantic-ui-react";
import { DiagramContext, DiagramMode } from "../diagram-context";

export const ModeToggleButton: StatelessComponent<{}> = () => {
    return  (
        <DiagramContext.Consumer>
            {({ mode: currentMode, changeMode, hasSyntaxErrors }) => {
                const icon = currentMode === DiagramMode.ACTION
                    ? "fw-expand"
                    : "fw-collapse";
                const toolTip = currentMode === DiagramMode.ACTION
                    ? "Expand Code"
                    : "Collapse Code";
                return (
                    <Menu.Item>
                        <Button.Group size="tiny">
                            <Button
                                disabled={hasSyntaxErrors}
                                icon
                                onClick={() => {
                                    if (currentMode === DiagramMode.ACTION) {
                                        changeMode(DiagramMode.DEFAULT);
                                    } else {
                                        changeMode(DiagramMode.ACTION);
                                    }
                                }}
                            >
                                <Icon className={`fw ${icon}`} title={toolTip} />
                            </Button>
                        </Button.Group>
                    </Menu.Item>
                );
            }}
        </DiagramContext.Consumer>
    );
};
