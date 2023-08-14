using Godot;
using System;


public partial class LogicPiece : Area2D
{
	public int colour;
	public StartEnd GetMoveEndpoints(Godot.Vector2[] from, Godot.Vector2[] to, int[] mv_types, int sq_w_pix, int logic_piece_radius)
	{
		int N = to.Length;
		Godot.ShapeCast2D shapeCast = GetNode("ShapeCast") as Godot.ShapeCast2D;
		for (int i = 0; i < N; i++)
		{
			Godot.Vector2 startPos = from[i] * sq_w_pix;
			Godot.Vector2 endPos;
			shapeCast.Position = startPos;
			shapeCast.TargetPosition = to[i] * sq_w_pix;
			shapeCast.ForceShapecastUpdate();
			int collideCount = shapeCast.GetCollisionCount();
			if (collideCount > 0)
			{
				Godot.Area2D collideObj = shapeCast.GetCollider(0) as Area2D;
				Godot.Vector2 dir = (to[i] - from[i]).Normalized();

			}
			else
			{
				endPos = from[i] * sq_w_pix;
			}






			Console.WriteLine("foo");
		}

	}

	public Godot.Vector2 mapValidRaycastToPos(Godot.Vector2 dir, LogicPiece collideObj, Godot.Vector2 globalCollisionPoint,
	int mv_type, int logicPieceRadius)
	{
		Godot.Vector2 epsilon = 0.5f * dir;
		Godot.Vector2 collisionPointToSelf = globalCollisionPoint - GlobalPosition;
		Godot.Vector2 allowedEndPoint = collisionPointToSelf.Length() * dir - logicPieceRadius * dir - epsilon;
		bool attacking = (collideObj.colour != colour) && (collideObj.colour > -1);





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
