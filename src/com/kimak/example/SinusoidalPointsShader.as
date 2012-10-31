package com.kimak.example {
import aerys.minko.render.RenderTarget;
import aerys.minko.render.geometry.stream.format.VertexComponent;
import aerys.minko.render.geometry.stream.format.VertexComponentType;
import aerys.minko.render.geometry.stream.format.VertexFormat;
import aerys.minko.render.shader.SFloat;
import aerys.minko.render.shader.Shader;
import aerys.minko.render.shader.ShaderSettings;
import aerys.minko.type.enum.Blending;
import aerys.minko.type.enum.DepthTest;
import aerys.minko.type.enum.TriangleCulling;

public class SinusoidalPointsShader extends Shader {
    public static const POINT_OFFSET:VertexComponent = new VertexComponent(
            ['phase', 'speed'],
            VertexComponentType.FLOAT_2
    );

    public static const RANDOM_OFFSET:VertexComponent = new VertexComponent(
            ['randomX', 'randomAlpha'],
            VertexComponentType.FLOAT_2
    );
    public static const POINT_DATA:VertexComponent = new VertexComponent(
            ['offsetX', 'offsetY'],
            VertexComponentType.FLOAT_2
    );

    public static const VERTEX_FORMAT:VertexFormat = new VertexFormat(
            POINT_DATA,
            RANDOM_OFFSET,
            POINT_OFFSET,
            VertexComponent.XYZ,
            VertexComponent.RGB
    );

    private var _varColor:SFloat = null;

    public function SinusoidalPointsShader(target:RenderTarget = null, priority:Number = 0.0) {
        super(target, priority);
    }

    override protected function initializeSettings(settings:ShaderSettings):void {
        super.initializeSettings(settings);

        settings.triangleCulling = TriangleCulling.NONE;
        settings.blending = Blending.ADDITIVE;
        settings.depthWriteEnabled = false;
        settings.depthTest = DepthTest.ALWAYS;
    }


    override protected function getVertexPosition():SFloat {

        var amplitude:SFloat = meshBindings.getParameter('amplitude', 1);
        var shiftValue:SFloat = meshBindings.getParameter('shift', 1);
        var frequence:SFloat = meshBindings.getParameter('frequence', 1);
        var moveX:SFloat = meshBindings.getParameter('moveX', 1);
        var offsetX:SFloat = meshBindings.getParameter('offsetX', 1);

        var pointSize:SFloat = meshBindings.getParameter('pointSize', 1);
        var position:SFloat = getVertexAttribute(VertexComponent.XYZ);

        var uv:SFloat = getVertexAttribute(POINT_DATA).xy;

        var shift:SFloat = cos(add(multiply(uv.x, uv.y), uv.x));

        _varColor = vertexRGBColor;

        var corner:SFloat = multiply(
                getVertexAttribute(POINT_OFFSET),
                float4(pointSize.xx, 0, 0)
        );

        var random:SFloat = getVertexAttribute(RANDOM_OFFSET).x;

        var posX:SFloat = subtract(position.x, multiply(moveX, random));
        var repeatX:SFloat = modulo(posX, float(1))
        position.x = subtract(repeatX, 0.5);

        var pi:SFloat = float(2 * Math.PI);
        var freq:SFloat = multiply(pi, frequence);
        var angle:SFloat = multiply(freq, add(position.x, offsetX));

        position.y = multiply(amplitude, sin(angle));

        position = add(position, float4(0, power(multiply(shift, shiftValue), 1.5), 0, 0));

        position = localToView(position);
        position.incrementBy(corner);

        return multiply4x4(position, projectionMatrix);
    }


    override protected function getPixelColor():SFloat {

        var xy:SFloat = interpolate(getVertexAttribute(POINT_OFFSET).xy);
        var d:SFloat = dotProduct2(xy, xy);

        var random:SFloat = interpolate(getVertexAttribute(RANDOM_OFFSET).y);
        d = subtract(1, multiply(d, 4));

        kill(subtract(d, .2));

        var c:SFloat = interpolate(_varColor);
        c.w = random;

        c.scaleBy(power(d, 3));
        c.incrementBy(multiply(0.5, power(d, 20)));

        return c;
    }
}
}