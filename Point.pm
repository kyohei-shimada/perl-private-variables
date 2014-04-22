package Point;
use strict;
use warnings;
use Data::Dumper;
use Storable qw(nfreeze thaw);
use Crypt::CBC;
use Digest::MD5 qw(md5_hex);

my $private_key = "private_key";

my $encrypt = sub {
	my ($value) = @_;
	my $cipher = Crypt::CBC->new($private_key, 'DES');
	my $checksum = md5_hex($value . $private_key);
	return ($cipher->encrypt_hex($value), $checksum);
};

my $decrypt = sub {
	my ($value, $checksum) = @_;
	my $cipher = Crypt::CBC->new($private_key, 'DES');
	my $decrypted;
	eval {
		$decrypted = $cipher->decrypt_hex($value);
	};
	if($@) {
		die "cannot decrypte: incorrect format of a encrypted string";
	}

	unless ($checksum eq md5_hex($decrypted . $private_key)) {
		die "incorrect checksum";
	}

	return ($decrypted, $checksum);
};

sub new {
	my ($class, $x, $y) = @_;
	my $private = {
		"x" => $x,
		"y" => $y,
	};
	my $frozen = nfreeze $private;
	
	print "===========\nprivate\n===========\n";
	print Dumper $private;

	my ($encrypted, $checksum) = $encrypt->($frozen);

	my $self = {
		"private" => $encrypted,
		"checksum" => $checksum,
	};
	return bless $self, $class;
}

sub x {
	my ($this) = @_;
    my $private = thaw $decrypt->($this->{private}, $this->{checksum});
	return $private->{"x"};
}

sub y {
	my ($this) = @_;
    my $private = thaw $decrypt->($this->{private}, $this->{checksum});
	return $private->{"y"};
}

