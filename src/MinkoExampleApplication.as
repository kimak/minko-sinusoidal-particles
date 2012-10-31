package {
import aerys.minko.Minko;
import aerys.minko.render.Viewport;
import aerys.minko.scene.controller.camera.ArcBallController;
import aerys.minko.scene.node.Scene;
import aerys.minko.scene.node.camera.Camera;
import aerys.minko.type.log.DebugLevel;
import aerys.monitor.Monitor;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

public class MinkoExampleApplication extends Sprite {
    private var _viewport:Viewport;
    private var _camera:Camera = null;

    private var _scene:Scene = new Scene();

    private var _buildForMobile:Boolean;

    protected function get viewport():Viewport {
        return _viewport;
    }

    protected function get camera():Camera {
        return _camera;
    }

    protected function get scene():Scene {
        return _scene;
    }

    public function MinkoExampleApplication() {

        if (stage)
            initialize();
        else
            addEventListener(Event.ADDED_TO_STAGE, initialize);

    }

    private function initialize(event:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, initialize);


        if (!this.buildForMobile) {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
        }

        _viewport = new Viewport(0, stageWidth, stageHeight);
        stage.addChildAt(_viewport, 0);

        initializeScene();
        initializeUI();

        stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    protected function initializeScene():void {
        _camera = new Camera();
        _scene.addChild(camera);
    }

    protected function initializeUI():void {
        stage.addChild(Monitor.monitor.watch(_scene, ['numDescendants', 'numTriangles', 'numPasses']));
    }

    protected function enterFrameHandler(event:Event):void {
        _scene.render(_viewport);
    }

    /**
     * Custom workaround to catch good with on mobile and desktop
     *@see http://www.adobe.com/devnet/air/articles/multiple-screen-sizes.html
     */
    public function get stageWidth():Number {
        if (_buildForMobile) return stage.fullScreenWidth;
        return stage.stageWidth;
    }


    /**
     * Custom workaround to catch good height on mobile and desktop
     *@see http://www.adobe.com/devnet/air/articles/multiple-screen-sizes.html
     */
    public function get stageHeight():Number {
        if (_buildForMobile) return stage.fullScreenHeight;
        return stage.stageHeight;
    }


    public function set buildForMobile(value:Boolean):void {
        _buildForMobile = value;
    }

    public function get buildForMobile():Boolean {
        return _buildForMobile;
    }
}
}