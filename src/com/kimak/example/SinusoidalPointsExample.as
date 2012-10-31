package com.kimak.example {
import aerys.minko.render.Effect;
import aerys.minko.render.material.Material;
import aerys.minko.scene.node.Mesh;

import flash.events.Event;

public class SinusoidalPointsExample extends MinkoExampleApplication {

    private var _shaderEffect:Effect;

    private var _linesMesh:Vector.<MeshVo> = new Vector.<MeshVo>();


    private const GLOBAL_SPEED:Number = 4.0;
    private const GLOBAL_PARTICLES:Number = 0.5;

    public function SinusoidalPointsExample() {
        // Set this property to choose mobile target for stage.fullscreenWidth value instead of wrong stage.stageWidth value
        this.buildForMobile = true;

        super();
    }

    override protected function initializeScene():void {

        _shaderEffect = new Effect(new SinusoidalPointsShader());

        super.initializeScene();

        createLines();
    }

    private function createLines():void {

        var lineVo:LineVo = new LineVo();

        lineVo.numPoints = stageWidth * 4;
        lineVo.y = 0;
        lineVo.alpha = 0.2;
        lineVo.randomize = false;
        lineVo.pointSize = 0.015;
        lineVo.amplitude = 0.22;
        lineVo.frequence = 3.2;
        lineVo.speedOffsetX = 0.001;
        lineVo.shift = 0.0;
        lineVo.color = 0.0;
        lineVo.offsetX = -0.05;
        createLineFromVo(lineVo);

        lineVo.numPoints = stageWidth * 1.0;
        lineVo.y = -0.02;
        lineVo.alpha = 0.5;
        lineVo.randomize = true;
        lineVo.pointSize = 0.015;
        lineVo.amplitude = 0.22;
        lineVo.frequence = 3.2;
        lineVo.speedOffsetX = 0.001;
        lineVo.pointSize = 0.007;
        lineVo.shift = 0.1;
        lineVo.color = 0.0;
        lineVo.offsetX = -0.05;
        createLineFromVo(lineVo);


        lineVo.numPoints = stageWidth * 0.5;
        lineVo.y = 0;
        lineVo.alpha = 0.5;
        lineVo.randomize = true;
        lineVo.pointSize = 0.006;
        lineVo.amplitude = 0.23;
        lineVo.frequence = 1.7;
        lineVo.speedOffsetX = 0.0015;
        lineVo.shift = 0.04;
        lineVo.color = 0xFFFFFF;
        lineVo.offsetX = -0.15;
        createLineFromVo(lineVo);


        lineVo.numPoints = stageWidth * 0.75;
        lineVo.y = 0;
        lineVo.alpha = 0.5;
        lineVo.randomize = true;
        lineVo.pointSize = 0.005;
        lineVo.amplitude = 0.10;
        lineVo.frequence = 2.6;
        lineVo.speedOffsetX = 0.0012;
        lineVo.shift = 0.05;
        lineVo.color = 0xFFFFFF;
        lineVo.offsetX = 0.52;
        createLineFromVo(lineVo);

        lineVo.numPoints = stageWidth * 0.2;
        lineVo.y = 0;
        lineVo.alpha = 0.5;
        lineVo.randomize = true;
        lineVo.pointSize = 0.004;
        lineVo.amplitude = 0.32;
        lineVo.frequence = -1.8;
        lineVo.speedOffsetX = 0.001;
        lineVo.shift = 0.08;
        lineVo.color = 0xFFFFFF;
        lineVo.offsetX = 0.0;
        createLineFromVo(lineVo);

        lineVo.numPoints = stageWidth * 0.25;
        lineVo.y = -0.05;
        lineVo.alpha = 0.5;
        lineVo.randomize = true;
        lineVo.pointSize = 0.004;
        lineVo.amplitude = 0.13;
        lineVo.frequence = 2.4;
        lineVo.speedOffsetX = 0.0017;
        lineVo.shift = 0.2;
        lineVo.color = 0xFFFFFF;
        lineVo.offsetX = 0.05;
        createLineFromVo(lineVo);

    }

    private function createLineFromVo(lineVo:LineVo):Mesh {

        var parameters:Object = {pointSize:lineVo.pointSize, amplitude:lineVo.amplitude, frequence:lineVo.frequence, moveX:0, shift:lineVo.shift, offsetX:lineVo.offsetX};

        var line:Mesh = new Mesh(new SinusoidalPointsGeometry(lineVo.numPoints * GLOBAL_PARTICLES, lineVo.color, lineVo.alpha, lineVo.randomize),
                new Material(
                        _shaderEffect,
                        parameters
                )
        );
        scene.addChild(line);
        line.y = lineVo.y;

        var meshVo:MeshVo = new MeshVo();
        meshVo.mesh = line;
        meshVo.moveSpeedX = lineVo.speedOffsetX * GLOBAL_SPEED;

        _linesMesh.push(meshVo);
        return line;
    }


    override protected function enterFrameHandler(event:Event):void {

        var i:int, nb:int = _linesMesh.length;
        for (i = 0; i < nb; ++i) {
            _linesMesh[i].moveX -= _linesMesh[i].moveSpeedX;
            _linesMesh[i].offsetX -= _linesMesh[i].moveSpeedX * 0.05 * GLOBAL_SPEED;

            //move particles
            _linesMesh[i].mesh.material.setProperty("moveX", _linesMesh[i].moveX);

            //move line
            _linesMesh[i].mesh.material.setProperty("offsetX", _linesMesh[i].offsetX);
        }

        super.enterFrameHandler(event);
    }

}
}

import aerys.minko.scene.node.Mesh;

class MeshVo {

    public var mesh:Mesh;
    public var moveX:Number = 0;
    public var offsetX:Number = 0;
    public var moveSpeedX:Number = 0;

}

class LineVo {

    public var numPoints:Number = 1000;
    public var y:Number = 0.0;
    public var alpha:Number = 0.5;
    public var pointSize:Number = 0.005;
    public var amplitude:Number = 2;
    public var frequence:Number = 10;
    public var offsetX:Number = 0;
    public var speedOffsetX:Number = 0.005;
    public var shift:Number = 0.05;
    public var color:Number = 0xFFFFFF;
    public var randomize:Boolean = true;

}