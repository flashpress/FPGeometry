package ru.flashpress.geom.polygon.math
{
    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;

    import ru.flashpress.geom.core.ns.geometry2d;
	import ru.flashpress.geom.line.FPGLine2d;
	import ru.flashpress.geom.line.math.FPGLineToLine2dMath;
	import ru.flashpress.geom.line.math.FPGLineToPoint2dMath;
	import ru.flashpress.geom.point.FPGPoint2d;
	import ru.flashpress.geom.point.math.FPGPoint2dMath;
	import ru.flashpress.geom.polygon.FPGEdge2d;
	import ru.flashpress.geom.polygon.FPGPolygon2d;
	import ru.flashpress.geom.polygon.FPGVertex2d;

	/**
	 * Математические операции двух Полигонов
	 * @author Serious Sam
	 */
	public class FPGPolyToPoly2dMath
	{
		use namespace geometry2d;
		//
		//
		// PRIVATE METHODS *****************************************************************
		//
		//
		/**
		 * Найти все отрезки пересечения всех ребер полигона p1 с полигоном p2 
		 */
		private static function getCrossLines(p1:FPGPolygon2d, p2:FPGPolygon2d, duplicates:Object):Vector.<FPGLine2d>
		{
			var edges1:Vector.<FPGEdge2d> = p1._edges;
			var ec1:int = edges1.length;
			//
			var i:int;
			var edge:FPGEdge2d;
			var lines:Vector.<FPGLine2d> = new Vector.<FPGLine2d>();
			var cross:FPGLine2d;
			for (i=0; i<ec1; i++) {
				edge = edges1[i];
				cross = FPGPolyToLine2dMath.crossPiece(p2, edge);
				if (cross != null) {
					if (!duplicates[cross._p1.id+'-'+cross._p2.id] &&
						!duplicates[cross._p2.id+'-'+cross._p1.id])
					{
						duplicates[cross._p1.id+'-'+cross._p2.id] = true;
						duplicates[cross._p2.id+'-'+cross._p1.id] = true;
						lines.push(cross);
					}
				}
			}
			return lines;
		}
		
		/**
		 * Найти все отрезки отсечения всех ребер полигона p1 полигоном p2 
		 */
		private static function getSubLines(p1:FPGPolygon2d, p2:FPGPolygon2d, duplicates:Object):Vector.<FPGLine2d>
		{
			var edges1:Vector.<FPGEdge2d> = p1._edges;
			var ec1:int = edges1.length;
			//
			var edge:FPGEdge2d;
			var lines:Vector.<FPGLine2d> = new Vector.<FPGLine2d>();
			var crossLines:Vector.<FPGLine2d>;
			var cross:FPGLine2d;
			var i:int;
			var j:int;
			for (i=0; i<ec1; i++) {
				edge = edges1[i];
				crossLines = FPGPolyToLine2dMath.subPiece(p2, edge);
				for (j=0; j<crossLines.length; j++) {
					cross = crossLines[j];
					if (!duplicates[cross._p1.id+'-'+cross._p2.id] &&
						!duplicates[cross._p2.id+'-'+cross._p1.id])
					{
						duplicates[cross._p1.id+'-'+cross._p2.id] = true;
						duplicates[cross._p2.id+'-'+cross._p1.id] = true;
						lines.push(cross);
					}
				}
			}
			return lines;
		}
		
		/**
		 * Удалить из l2 дублирующиеся отрезки и вернуть список удаленных
		 */
		private static function removeCopyPieces(l1:Vector.<FPGLine2d>, l2:Vector.<FPGLine2d>):Vector.<FPGLine2d>
		{
			var lines:Vector.<FPGLine2d> = new Vector.<FPGLine2d>();
			var i:int;
			var j:int;
			var c1:int = l1.length;
			var c2:int = l2.length;
			for (i=0; i<c1; i++) {
				j = 0;
				while (j < c2) {
					if (l1[i].compare(l2[j], true)) {
						lines.push(l2[j]);
						l2.splice(j, 1);
						c2 = l2.length;
					} else {
						j++;
					}
				}
			}
			return lines;
		}
		//
		//
		// PUBLIC METHODS *****************************************************************
		//
		//
		/**
		 * Геометрический центр треугольника
		 * @param a Первая точка треугольника
		 * @param b Вторая точка треугольника
		 * @param c Третья точка треугольника
		 */
		public static function triangleCenter(a:FPGPoint2d, b:FPGPoint2d, c:FPGPoint2d):FPGPoint2d
		{
			//var cx:Number = (a._x+b._x+c._x)/3;
			//var cy:Number = (a._y+b._y+c._y)/3;
			return new FPGPoint2d((a._x+b._x+c._x)/3, (a._y+b._y+c._y)/3);
		}
		
		//private static var vec_AB_ts:FPGVector2d;
		//private static var vec_AC_ts:FPGVector2d;
		private static var mod_AB:Number;
		private static var mod_AC:Number;
		private static var angle_ts:Number;
		/**
		 * Площадь треугольника
		 * @param a Первая точка треугольника
		 * @param b Вторая точка треугольника
		 * @param c Третья точка треугольника
		 */
		public static function triangleSquare(a:FPGPoint2d, b:FPGPoint2d, c:FPGPoint2d):Number
		{
			//vec_AB_ts = new FPGVector2d(b._x-a._x, b._y-a._y);
			//vec_AC_ts = new FPGVector2d(c._x-a._x, c._y-a._y);
			//angle_ts = FPGVector2dMath.angleBetween(vec_AB_ts, vec_AC_ts);
			mod_AB = FPGPoint2dMath.length(a, b);
			mod_AC = FPGPoint2dMath.length(a, c);
			angle_ts = FPGPoint2dMath.angleBetweenLines(a, b, a, c);
			return Math.abs(mod_AB*mod_AC*Math.sin(angle_ts)/2);
		}
		
		/**
		 * Пересечение полигонов. Если полигоны не пересекаются, вернет null.
		 * Если есть вероятность того, что объекты находятся далеко друг от друга,
		 * тогда есть смысл перед вызовом этого метода, проверять на пересечение их ограничивающих прямоугольников
		 * с помощью метода: FPGBoundsMath.сross(p1.bounds, p2.bounds); 
		 * Даннй метод не осуществляет такую проверку.
		 */
		public static function cross(p1:FPGPolygon2d, p2:FPGPolygon2d):FPGPolygon2d
		{
			var duplicates:Object = {};
			var e1:Vector.<FPGLine2d> = getCrossLines(p1, p2, duplicates);
			//
			var e2:Vector.<FPGLine2d> = getCrossLines(p2, p1, duplicates);
            if (e1.length == 0 && e2.length == 0) return null;
			//
			var edges:Vector.<FPGLine2d> = e1.concat(e2);
			var edge:FPGLine2d = edges.shift();
			var points:Vector.<FPGPoint2d> = new Vector.<FPGPoint2d>();
			points.push(edge._p1.clone());
			if (!edge._p1.compare(edge._p2)) {
				points.push(edge._p2.clone());
			}
			//
			var start:FPGPoint2d = edge._p1;
			var end:FPGPoint2d = edge._p2;
			var i:int;
			var ec:int = edges.length;
            var tempIndex:int = 0;
			while (ec > 0 && tempIndex++<20) {
				for (i=0; i<ec; i++) {
					edge = edges[i];
					if (end.compare(edge._p1)) {
						edges.splice(i, 1);
						if (!start.compare(edge._p2)) {
							start = end;
							end = edge._p2;
							points.push(edge._p2.clone());
						}
						ec = edges.length;
						break;
					} else if (end.compare(edge._p2)) {
						edges.splice(i, 1);
						if (!start.compare(edge._p1)) {
							start = end;
							end = edge._p1;
							points.push(edge._p1.clone());
						}
						ec = edges.length;
						break;
					}
				}
			}
			if (points.length > 2) {
				return new FPGPolygon2d(points);
			} else {
				return null;
			}
		}
		
		/**
		 * Объеденить два полигона. Если есть вероятность того, что объекты находятся далеко друг от друга,
		 * тогда есть смысл перед вызовом этого метода, проверять на пересечение их ограничивающих прямоугольников
		 * с помощью метода: FPGBoundsMath.сross(p1.bounds, p2.bounds);
		 * Если прямоугольники не пересекаются - результатом будет p1.clone()+p2.clone(); 
		 * Даннй метод не осуществляет такую проверку.
		 * @return Массив полигонов.
		 */
		public static function add(p1:FPGPolygon2d, p2:FPGPolygon2d):Vector.<FPGPolygon2d>
		{
			var duplicates:Object = {};
			var e1:Vector.<FPGLine2d> = getSubLines(p1, p2, duplicates);
			//
			if (e1.length == 0) return null;
			var e2:Vector.<FPGLine2d> = getSubLines(p2, p1, duplicates);
			//
			var edges:Vector.<FPGLine2d> = e1.concat(e2);
			var edge:FPGLine2d = edges.shift();
			//
			var pointsList:Vector.<Vector.<FPGPoint2d>> = new Vector.<Vector.<FPGPoint2d>>();
			var points:Vector.<FPGPoint2d> = new Vector.<FPGPoint2d>();
			pointsList.push(points);
			points.push(edge._p1.clone());
			//
			if (!edge._p1.compare(edge._p2)) {
				points.push(edge._p2.clone());
			}
			var start:FPGPoint2d = edge._p1;
			var end:FPGPoint2d = edge._p2;
			//
			var i:int;
			var ec:int = edges.length;
			var isComplete:Boolean;
			while (ec > 0) {
				isComplete = false;
				for (i=0; i<ec; i++) {
					edge = edges[i];
					if (end.compare(edge._p1)) {
						edges.splice(i, 1);
						if (!start.compare(edge._p2)) {
							start = end;
							end = edge._p2;
							points.push(edge._p2.clone());
						}
						ec = edges.length;
						isComplete = true;
						break;
					} else if (end.compare(edge._p2)) {
						edges.splice(i, 1);
						if (!start.compare(edge._p1)) {
							start = end;
							end = edge._p1;
							points.push(edge._p1.clone());
						}
						ec = edges.length;
						isComplete = true;
						break;
					}
				}
				if (!isComplete) {
					edge = edges.shift();
					ec = edges.length;
					points = new Vector.<FPGPoint2d>();
					pointsList.push(points);
					points.push(edge._p1.clone());
					//
					if (!edge._p1.compare(edge._p2)) {
						points.push(edge._p2.clone());
					}
					start = edge._p1;
					end = edge._p2;
				}
			}
			//
			var polygons:Vector.<FPGPolygon2d> = new Vector.<FPGPolygon2d>();
			var pc:int = pointsList.length;
			for (i=0; i<pc; i++) {
				points = pointsList[i];
				if (points.length > 2) {
					polygons.push(new FPGPolygon2d(points));
				}
				points.length = 0;
			}
			pointsList.length = 0;
			//
			return polygons;
		}
		
		
		/**
		 * Вычесть из полигона p1, полигон p2
		 * Если есть вероятность того, что объекты находятся далеко друг от друга,
		 * тогда есть смысл перед вызовом этого метода, проверять на пересечение их ограничивающих прямоугольников
		 * с помощью метода: FPGBoundsMath.сross(p1.bounds, p2.bounds);
		 * Если прямоугольники не пересекаются - результатом будет p1.clone();
		 * @return Массив полигонов
		 */
		public static function sub(p1:FPGPolygon2d, p2:FPGPolygon2d):Vector.<FPGPolygon2d>
		{
			var duplicates:Object = {};
			var e1:Vector.<FPGLine2d> = getSubLines(p1, p2, duplicates);
			//
			if (e1.length == 0) return null;
			var e2:Vector.<FPGLine2d> = getCrossLines(p2, p1, duplicates);
			//
			var edges:Vector.<FPGLine2d> = e1.concat(e2);
			var edge:FPGLine2d = edges.shift();
			//
			var pointsList:Vector.<Vector.<FPGPoint2d>> = new Vector.<Vector.<FPGPoint2d>>();
			var points:Vector.<FPGPoint2d> = new Vector.<FPGPoint2d>();
			pointsList.push(points);
			points.push(edge._p1.clone());
			//
			if (!edge._p1.compare(edge._p2)) {
				points.push(edge._p2.clone());
			}
			var start:FPGPoint2d = edge._p1;
			var end:FPGPoint2d = edge._p2;
			//
			var i:int;
			var ec:int = edges.length;
			var isComplete:Boolean;
			while (ec > 0) {
				isComplete = false;
				for (i=0; i<ec; i++) {
					edge = edges[i];
					if (end.compare(edge._p1)) {
						edges.splice(i, 1);
						if (!start.compare(edge._p2)) {
							start = end;
							end = edge._p2;
							points.push(edge._p2.clone());
						}
						ec = edges.length;
						isComplete = true;
						break;
					} else if (end.compare(edge._p2)) {
						edges.splice(i, 1);
						if (!start.compare(edge._p1)) {
							start = end;
							end = edge._p1;
							points.push(edge._p1.clone());
						}
						ec = edges.length;
						isComplete = true;
						break;
					}
				}
				if (!isComplete) {
					edge = edges.shift();
					ec = edges.length;
					points = new Vector.<FPGPoint2d>();
					pointsList.push(points);
					points.push(edge._p1.clone());
					//
					if (!edge._p1.compare(edge._p2)) {
						points.push(edge._p2.clone());
					}
					start = edge._p1;
					end = edge._p2;
				}
			}
			//
			var polygons:Vector.<FPGPolygon2d> = new Vector.<FPGPolygon2d>();
			var pc:int = pointsList.length;
			for (i=0; i<pc; i++) {
				points = pointsList[i];
				if (points.length > 2) {
					polygons.push(new FPGPolygon2d(points));
				}
			}
			//
			return polygons;
		}
		
		private static var edges1:Vector.<FPGEdge2d>;
		private static var edges2:Vector.<FPGEdge2d>;
		private static var edge1:FPGEdge2d;
		private static var edge2:FPGEdge2d;
		/**
		 * Пересечение ребер двух полигонов. Если один полигон полностью погружен в другой,
		 * и при этом ребра не пересекаются, то метод вернет значение false.
		 * Для определения пересечения с полной погруженностью используйте метод FPGPolyToPoly2dMath.isCross.
		 * Если есть вероятность того, что объекты находятся далеко друг от друга,
		 * тогда есть смысл перед вызовом этого метода, проверять на пересечение их ограничивающих прямоугольников
		 * с помощью метода: FPGBoundsMath.сross(p1.bounds, p2.bounds);
		 */
		public static function isCrossEdges(p1:FPGPolygon2d, p2:FPGPolygon2d):Boolean
		{
			edges1 = p1._edges;
			const ec1:int = edges1.length;
			edges2 = p2._edges;
			const ec2:int = edges2.length;
			var i:int;
			var j:int;
			for (i=0; i<ec1; i++) {
				edge1 = edges1[i];
				for (j=0; j<ec2; j++) {
					edge2 = edges2[j];
					if (FPGLineToLine2dMath.isCrossPiece(edge1, edge2))
						return true;
				}
			}
			//
			return false;
		}
		
		
		private static var i:int;
		private static var _vx:FPGVertex2d;
		private static var _vxs:Vector.<FPGVertex2d>;
		/**
		 * Пересечение двух полигонов(в т.ч. и полное погружение одного в другой)
		 * Если есть вероятность того, что объекты находятся далеко друг от друга,
		 * тогда есть смысл перед вызовом этого метода, проверять на пересечение их ограничивающих прямоугольников
		 * с помощью метода: FPGBoundsMath.сross(p1.bounds, p2.bounds);
		 */
		public static function isCross(p1:FPGPolygon2d, p2:FPGPolygon2d):Boolean
		{
			_vxs = p2._vertexes;
			i = _vxs.length;
			while (i--) {
				_vx = _vxs[i];
				if (FPGPolyToPoint2dMath.contains(_vx, p1)) 
					return true;
			}
			//
			_vxs = p1._vertexes;
			i = _vxs.length;
			while (i--) {
				_vx = _vxs[i];
				if (FPGPolyToPoint2dMath.contains(_vx, p2))
					return true;
			}
			//
			return false;
		}
		
		/**
		 * Описать один прямоугольник вокруг другого
		 * @param polyIn
		 * @param polyOut
		 * @return 
		 * 
		 */
		public static function describeRect(polyIn:FPGPolygon2d, polyOut:FPGPolygon2d):FPGPolygon2d
		{
			var i:int;
			var j:int;
			var vertex:FPGVertex2d;
			var edge:FPGEdge2d;
			var heightLine:FPGLine2d;
			//
			var leftPoint:FPGVertex2d;
			var leftEdge:FPGEdge2d;
			var maxScale:Number = 1;
			for (i=0; i<polyIn.vertexes.length; i++) {
				vertex = polyIn.vertexes[i];
				for (j=0; j<polyOut.edges.length; j++) {
					edge = polyOut.edges[j];
					if (edge.valueFromPoint(vertex) <= 0) continue;
					heightLine = FPGLineToPoint2dMath.lineHeight(vertex, edge);
					//
					leftPoint = edge.p1 as FPGVertex2d;
					leftEdge = leftPoint.leftEdge;
					maxScale = Math.max(maxScale, (leftEdge.length+heightLine.length*2)/leftEdge.length);
				}
			}
			//
			var poly:FPGPolygon2d = polyOut.clone();
			poly.scale(maxScale, maxScale);
			return poly;
		}
	}
}