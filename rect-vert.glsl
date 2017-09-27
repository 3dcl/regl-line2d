precision highp float;

attribute vec2 aCoord, bCoord, aCoordFract, bCoordFract;
attribute vec4 color;
attribute float lineEnd, lineTop;

uniform vec2 scale, scaleFract, translate, translateFract, scaleRatio;
uniform float thickness, pixelRatio, id;
uniform vec4 viewport;

varying vec4 fragColor;
varying vec2 tangent;

const float MAX_LINES = 256.;

vec2 project(vec2 position, vec2 positionFract, vec2 scale, vec2 scaleFract, vec2 translate, vec2 translateFract) {
  return (position + translate) * scale
       + (positionFract + translateFract) * scale
       + (position + translate) * scaleFract
       + (positionFract + translateFract) * scaleFract;
}

void main() {
	// vec2 scaleRatio = scale * viewport.zw;
	vec2 normalWidth = thickness / scaleRatio;

	float lineStart = 1. - lineEnd;
	float lineOffset = lineTop * 2. - 1.;
	float depth = (MAX_LINES - 1. - id) / (MAX_LINES);

	vec2 diff = bCoord - aCoord;
	tangent = normalize(diff * scaleRatio);
	vec2 normal = vec2(-tangent.y, tangent.x);

	vec2 position = project(aCoord, aCoordFract, scale, scaleFract, translate, translateFract) * lineStart
		+ project(bCoord, bCoordFract, scale, scaleFract, translate, translateFract) * lineEnd

		+ thickness * normal * .5 * lineOffset / viewport.zw;

	gl_Position = vec4(position * 2.0 - 1.0, depth, 1);

	fragColor = color / 255.;
}