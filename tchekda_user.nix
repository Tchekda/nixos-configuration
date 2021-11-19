{ pkgs, ... }:
{
  users.users.tchekda = {
    description = "David Tchekachev";
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAzZARI4tFaQ1T2g5Ug63IXpoLlKYTqnBoja/wam/+QsVH2I4/9t/LBS675+xWJ55UdTpxhkcHYplcvdR4PB3gR5rK/Eqqv7lZEpyriarfdiBuOS0XBYJANpDsGuzeAU7SPL2Kxn8FyWMxqQZeCHyO5fTXhOAUhay5C7n0ym7Ep1Lck3l9eT+sNOPNa5F+bnWheeQG4HkueBiSqt1nUCZA1NQnyvBAFP439/oNVkBXe5q/63eSuDdbq45h5HgR8512HZO857oceLql6PFWIhaG0eF0ifgwqcbNN7iNJ3wFUigb/nR0WZgJwLdUxzUIWyLZz/7Lwn+RatKIL/uicfb/ tchekda@Tchekda" # ASUS computer
    ];
  };
}
