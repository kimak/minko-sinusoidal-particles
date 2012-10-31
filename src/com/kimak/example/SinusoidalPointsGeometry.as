package com.kimak.example {
import aerys.minko.render.geometry.Geometry;
import aerys.minko.render.geometry.stream.IVertexStream;
import aerys.minko.render.geometry.stream.IndexStream;
import aerys.minko.render.geometry.stream.StreamUsage;
import aerys.minko.render.geometry.stream.VertexStream;

public class SinusoidalPointsGeometry extends Geometry {


    public function SinusoidalPointsGeometry(numPoints:uint = 1000, color:Number = 0xffffff, alpha:Number = 0.5, randomize:Boolean = true) {

        var vertices:Vector.<Number> = new <Number>[];
        var indices:Vector.<uint> = new <uint>[];

        var r:Number = color;
        var g:Number = color;
        var b:Number = color;


        for (var x:uint = 0; x < numPoints; ++x) {

            var posY:Number = 0;
            var posX:Number = 0;
            var randomSpeed:Number;
            var randomAlpha:Number;

            if (randomize) {
                posX = -0.5+1* Math.random();
                randomSpeed = 0.5 + Math.random() * 0.5;
                randomAlpha = alpha + Math.random() * (1 - alpha);
            } else {
                posX = -0.5 + x / numPoints;
                randomSpeed = 1;
                randomAlpha = alpha;
            }

            var posZ:Number = 1.5;

            var o:uint = x << 2;
            var phase:Number = -5 + Math.random() * 02.5;
            var speed:Number = Math.random() * 0.001;

            vertices.push(
                    phase, speed, randomSpeed, randomAlpha, -1.5, .5, posX, posY, posZ, r, g, b,
                    phase, speed, randomSpeed, randomAlpha, -1.5, -.5, posX, posY, posZ, r, g, b,
                    phase, speed, randomSpeed, randomAlpha, 1.5, -.5, posX, posY, posZ, r, g, b,
                    phase, speed, randomSpeed, randomAlpha, 1.5, .5, posX, posY, posZ, r, g, b
            );


            indices.push(o + 0, o + 1, o + 2, o + 0, o + 2, o + 3);
        }

        super(
                new <IVertexStream>[
                    VertexStream.fromVector(StreamUsage.STATIC, SinusoidalPointsShader.VERTEX_FORMAT, vertices)
                ],
                IndexStream.fromVector(StreamUsage.STATIC, indices)
        );
    }

}
}