
resource "aws_iam_role" "instance_role" {
  name = "${var.environment}-${var.project}-${var.role}-instance-role"
  assume_role_policy = "${data.template_file.instance_trust_policy.rendered}"
}

data "template_file" "instance_trust_policy" {
  template = "${file("${var.instance_policy}")}"
}

resource "aws_iam_policy" "instance-policy" {
  name        = "${var.project}-${var.environment}-${var.role}-instance-policy"
  description = "Ec2 policy"
  policy = "${data.template_file.instance_policy.rendered}"
}

data "template_file" "instance_policy" {
  template = "${file("${var.instance_policy}")}"
}

resource "aws_iam_role_policy_attachment" "attach-to" {
  role       = "${aws_iam_role.instance_role.name}"
  policy_arn = "${aws_iam_policy.instance-policy.arn}"
}

resource "aws_iam_instance_profile" "iProfile" {
  name = "${var.environment}-${var.project}-${var.role}-iProfile"
  role = "${aws_iam_role.instance_role.name}"
}

resource "aws_security_group" "allow_tls" {
  name        = "${var.environment}-${var.project}-${var.role}-sg"
  description = "Allow Ec2 pbdm worker inbound traffic"
  vpc_id      = "${var.vpc_id}"

   egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_rdaccess" {
  type            = "ingress"
  from_port       = 3389
  to_port         = 3389
  protocol        = "tcp"
  description     = "Allow access from remote desktop"
  # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  security_group_id = "${aws_security_group.allow_tls.id}"
  cidr_blocks     = ["217.133.84.68/32"]
}


module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  name = "${var.environment}-${var.project}-${var.role}--worker"

  # Launch configuration
  lc_name = "${var.environment}-${var.project}-${var.role}--worker"

  image_id        = "ami-0641fb28ff103057c"
  instance_type   = "t3.medium"
  iam_instance_profile = "${aws_iam_instance_profile.iProfile.name}"
  # Auto scaling group
  asg_name                  = "${var.environment}-${var.project}-${var.role}-asg"
  vpc_zone_identifier       = ["${var.subnet_ids}"]
  security_groups           = ["${aws_security_group.allow_tls.id}"]
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 0
  wait_for_capacity_timeout = 0
  associate_public_ip_address	= true
  tags = [
    {
      key                 = "Env"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "Proj"
      value               = "${var.project}"
      propagate_at_launch = true
    },
    {
      key                 = "Role"
      value               = "${var.role}"
      propagate_at_launch = true
    }
  ]
}


#ec2 for parquet conversion

