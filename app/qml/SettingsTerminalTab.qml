/*******************************************************************************
* Copyright (c) 2013 "Filippo Scognamiglio"
* https://github.com/Swordfish90/cool-retro-term
*
* This file is part of cool-retro-term.
*
* cool-retro-term is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*******************************************************************************/

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Tab{
    ColumnLayout{
        anchors.fill: parent
        GroupBox{
            title: qsTr("Rasterization Mode")
            Layout.fillWidth: true
            ComboBox {
                id: rasterizationBox
                property string selectedElement: model[currentIndex]
                anchors.fill: parent
                model: [qsTr("Default"), qsTr("Scanlines"), qsTr("Pixels")]
                currentIndex: shadersettings.rasterization
                onCurrentIndexChanged: {
                    shadersettings.rasterization = currentIndex
                    fontChanger.updateIndex();
                }
            }
        }
        GroupBox{
            title: qsTr("Font") + " (" + rasterizationBox.selectedElement + ")"
            Layout.fillWidth: true
            GridLayout{
                anchors.fill: parent
                columns: 2
                Text{ text: qsTr("Name") }
                ComboBox{
                    id: fontChanger
                    Layout.fillWidth: true
                    model: shadersettings.fontlist
                    currentIndex: updateIndex()
                    onActivated: {
                        shadersettings.fontIndexes[shadersettings.rasterization] = index;
                        shadersettings.handleFontChanged();
                    }
                    function updateIndex(){
                        currentIndex = shadersettings.fontIndexes[shadersettings.rasterization];
                    }
                }
                Text{ text: qsTr("Scaling") }
                RowLayout{
                    Layout.fillWidth: true
                    Slider{
                        Layout.fillWidth: true
                        id: fontScalingChanger
                        onValueChanged: if(enabled) shadersettings.fontScaling = value
                        stepSize: 0.05
                        enabled: false // Another trick to fix initial bad behavior.
                        Component.onCompleted: {
                            minimumValue = 0.5;
                            maximumValue = 2.5;
                            value = shadersettings.fontScaling;
                            enabled = true;
                        }
                        Connections{
                            target: shadersettings
                            onFontScalingChanged: fontScalingChanger.value = shadersettings.fontScaling;
                        }
                    }
                    Text{
                        text: Math.round(fontScalingChanger.value * 100) + "%"
                    }
                }
                Text{ text: qsTr("Font Width") }
                RowLayout{
                    Layout.fillWidth: true
                    Slider{
                        Layout.fillWidth: true
                        id: widthChanger
                        onValueChanged: shadersettings.fontWidth = value;
                        value: shadersettings.fontWidth
                        stepSize: 0.05
                        Component.onCompleted: minimumValue = 0.5 //Without this value gets set to 0.5
                    }
                    Text{
                        text: Math.round(widthChanger.value * 100) + "%"
                    }
                }
            }
        }
        GroupBox{
            title: qsTr("Colors")
            Layout.fillWidth: true
            ColumnLayout{
                anchors.fill: parent
                RowLayout{
                    Layout.fillWidth: true
                    ColorButton{
                        name: qsTr("Font")
                        height: 50
                        Layout.fillWidth: true
                        onColorSelected: shadersettings._font_color = color;
                        button_color: shadersettings._font_color
                    }
                    ColorButton{
                        name: qsTr("Background")
                        height: 50
                        Layout.fillWidth: true
                        onColorSelected: shadersettings._background_color = color;
                        button_color: shadersettings._background_color
                    }
                }
                ColumnLayout{
                    Layout.fillWidth: true
                    CheckableSlider{
                        name: qsTr("Chroma Color")
                        onNewValue: shadersettings.chroma_color = newValue
                        value: shadersettings.chroma_color
                    }
                    CheckableSlider{
                        name: qsTr("Saturation Color")
                        onNewValue: shadersettings.saturation_color = newValue
                        value: shadersettings.saturation_color
                        enabled: shadersettings.chroma_color !== 0
                    }
                }
            }
        }
    }
}
