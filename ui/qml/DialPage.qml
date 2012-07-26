/****************************************************************************
**
** Copyright (C) 2011-2012 Tom Swindell <t.swindell@rubyx.co.uk>
** All rights reserved.
**
** This file is part of the Voice Call UI project.
**
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * The names of its contributors may NOT be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
****************************************************************************/
import QtQuick 1.1
import com.nokia.meego 1.1

Page {
    id:root

    orientationLock:PageOrientation.LockPortrait

    BorderImage {
        anchors {fill:parent;topMargin:71}
        source:'images/meegotouch-page-background-inverted.png';
        border.left:20
        border.right:20
        border.top:0
        border.bottom:0
    }

    SelectionDialog {
        id:dProviderSelect
        model:providers

        onSelectedIndexChanged: {
            main.providerId = model.id(selectedIndex);
            main.providerType = model.type(selectedIndex);
            main.providerLabel = model.label(selectedIndex);
        }

        Component.onCompleted: selectedIndex = 0;
    }

    Button {
        id:bProviderSelect
        height:72
        anchors {left:parent.left;right:parent.right;top:parent.top;margins:1}
        platformStyle: ButtonStyle {
            background:'images/meegotouch-window-tabbutton-background-inverted.png'
            pressedBackground:'images/meegotouch-window-tabbutton-background-inverted.png'
        }

        text:main.providerLabel
        onClicked:dProviderSelect.open();
    }

    Item {
        anchors {top:bProviderSelect.bottom;bottom:numpad.top;left:parent.left;right:parent.right}

        TextEdit {
            id:iNumberEntry
            anchors {left:parent.left;right:bBackspace.left;verticalCenter:parent.verticalCenter;leftMargin:30;rightMargin:20}
            readOnly:true
            inputMethodHints:Qt.ImhDialableCharactersOnly
            color:main.appTheme.foregroundColor
            font.pixelSize:64
            horizontalAlignment:TextEdit.AlignRight

            onTextChanged: {
                resizeText();
            }

            function resizeText() {
                if(paintedWidth < 0 || paintedHeight < 0) return;
                while(paintedWidth > width)
                {
                    if(font.pixelSize <= 0) break;
                    font.pixelSize--;
                }

                while(paintedWidth < width)
                {
                    if(font.pixelSize >= 72) break;
                    font.pixelSize++;
                }
            }


            function appendChar(character)
            {
                if(iNumberEntry.text.length == 0) {
                    iNumberEntry.text = character
                } else {
                    iNumberEntry.text += character
                }
            }
        }

        Image {
            id:bBackspace
            anchors {verticalCenter:parent.verticalCenter;right:parent.right; margins:34}
            source:'images/icon-m-common-backspace.svg'
            MouseArea {
                anchors.fill:parent

                onClicked: {
                    if(iNumberEntry.text.length > 0) {
                        iNumberEntry.text = iNumberEntry.text.substring(0, iNumberEntry.text.length - 1);
                    }
                }
                onPressAndHold: {
                    if(iNumberEntry.text.length > 0) {
                        iNumberEntry.text = '';
                    }
                }
            }
        }
    }

    NumPad {
        id:numpad
        width:root.width;height:childrenRect.height
        anchors {bottom:rCallActions.top;margins:20}
    }

    Row {
        id:rCallActions
        width:childrenRect.width;height:childrenRect.height
        anchors {bottom:parent.bottom;horizontalCenter:parent.horizontalCenter;margins:30}

        AcceptButton {
            id:bCallNumber
            width:numpad.width * 0.66
            onClicked: {
                if(iNumberEntry.text.length > 0) {
                    main.dial(iNumberEntry.text);
                } else {
                    //TODO: Popup number error message.
                }
            }
        }
    }
}
