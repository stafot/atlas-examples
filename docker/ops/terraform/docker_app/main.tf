resource "docker_image" "app" {
    name = "${var.docker_image}"
    keep_updated = true
}

resource "docker_container" "app" {
    image = "${docker_image.app.latest}"
    name = "app_${count.index+1}"
    count = "${var.count}"
    command = [
        "-d -p 9999:80 ${var.docker_image} /usr/sbin/apache2ctl -D FOREGROUND",
        # "-d -P -t -i ${var.docker_image}",
        "sudo sed -i -- 's/{{ atlas_username }}/${var.atlas_username}/g' /etc/init/consul.conf",
        "sudo sed -i -- 's/{{ atlas_token }}/${var.atlas_token}/g' /etc/init/consul.conf",
        "sudo sed -i -- 's/{{ atlas_environment }}/${var.atlas_environment}/g' /etc/init/consul.conf",
        "sudo sed -i -- 's/{{ count }}/${var.count}/g' /etc/init/consul.conf",
        "sudo service consul restart"
    ]
    must_run = true
    publish_all_ports = true

    /*
    ports = {
        internal = "80"
        external = "80"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo sed -i -- 's/{{ atlas_username }}/${var.atlas_username}/g' /etc/init/consul.conf",
            "sudo sed -i -- 's/{{ atlas_token }}/${var.atlas_token}/g' /etc/init/consul.conf",
            "sudo sed -i -- 's/{{ atlas_environment }}/${var.atlas_environment}/g' /etc/init/consul.conf",
            "sudo service consul restart"
        ]
        connection {
            user = "${var.user}"
            key_file = "${var.key_file}"
            agent = "${var.agent}"
        }
    }
    */
}
