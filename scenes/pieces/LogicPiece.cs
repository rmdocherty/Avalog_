using Godot;
using System;


public partial class LogicPiece : Area2D
{
	[Export]
	public int colour { get; set; }

	public Godot.Vector2[][] GetMoveEndpoints(Godot.Vector2[] from, Godot.Vector2[] to, int[] mv_types, int sq_w_pix, int logic_piece_radius)
	{
		int N = to.Length;
		Godot.Vector2[] startPoints = new Godot.Vector2[N];
		Godot.Vector2[] endPoints = new Godot.Vector2[N];
		Godot.ShapeCast2D shapeCast = GetNode("ShapeCast") as Godot.ShapeCast2D;
		for (int i = 0; i < N; i++)
		{
			Godot.Vector2 startPos = from[i] * sq_w_pix;
			Godot.Vector2 rayEnd = to[i] * sq_w_pix;
			Godot.Vector2 endPos;

			shapeCast.Position = startPos;
			shapeCast.TargetPosition = rayEnd;
			shapeCast.ForceShapecastUpdate();
			int collideCount = shapeCast.GetCollisionCount();
			if (collideCount > 0)
			{
				LogicPiece collideObj = shapeCast.GetCollider(0) as LogicPiece;
				Godot.Vector2 dir = (to[i] - from[i]).Normalized();
				endPos = mapValidRaycastToPos(rayEnd, dir, collideObj, shapeCast.GetCollisionPoint(0), mv_types[i], logic_piece_radius);
			}
			else
			{
				endPos = rayEnd;
			}
			startPoints[i] = startPos;
			endPoints[i] = endPos;
		}
		Godot.Vector2[][] output = new Godot.Vector2[][] { startPoints, endPoints };
		return output;
	}

	public Godot.Vector2 mapValidRaycastToPos(Godot.Vector2 rayEnd, Godot.Vector2 dir, LogicPiece collideObj,
												Godot.Vector2 globalCollisionPoint, int mv_type, int logicPieceRadius)
	{
		/* */
		Godot.Vector2 norm_m = dir.Normalized();
		Godot.Vector2 epsilon = 0.5f * dir;
		Godot.Vector2 collisionPointToSelf = globalCollisionPoint - GlobalPosition;
		Godot.Vector2 allowedEndPoint = collisionPointToSelf.Length() * dir - logicPieceRadius * dir - epsilon;

		int attacking = Convert.ToSByte((collideObj.colour != colour) && (collideObj.colour > -1));
		int isLine = Convert.ToSByte(mv_type == 0);
		int isJumping = Convert.ToSByte(mv_type == 1);

		Godot.Vector2 nullVec = new Godot.Vector2(0, 0);
		Godot.Vector2 takeDist = 2 * logicPieceRadius * norm_m;
		Godot.Vector2 lineDist = attacking * isLine * (takeDist + allowedEndPoint);
		Godot.Vector2 jumpDist = attacking * isJumping * rayEnd + (1 - attacking) * isJumping * nullVec;

		Godot.Vector2 endPoint = lineDist + jumpDist;
		return endPoint;
	}

	public class StartEnd
	{
		public Godot.Vector2[] RaysStart { get; set; }
		public Godot.Vector2[] RaysEnd { get; set; }
		public StartEnd(Godot.Vector2[] rays_start, Godot.Vector2[] ray_send)
		{
			RaysStart = rays_start;
			RaysEnd = ray_send;
		}
	}
}

