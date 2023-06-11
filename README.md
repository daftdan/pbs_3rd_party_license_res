### PBS license checker
Small scripts that query various license servers (FlexNet, LM-X, LSTC) and return a single integer represent available licenses for a particular feature. With thanks to Adarsh of Altair https://community.openpbs.org/t/how-to-manage-flexnet-licensing-in-pbs-pro/1025/2

To configure PBS Professional / OpenPBS to handle software that has 'floating' network licenses controlled by services such as FLEXNet, Reprise, LM-X, you will need to define a new dynamic server-level custom resource.

use one of these scripts, customising as necessary, making sure it is executable, owned and only writable by the PBS server user (usually root). Tell the PBS server to createa new resource.

	qmgr -c "create resource lic_foo type=long"

Tell the PBS scheduler about the resource. Edit *$PBS_HOME/sched_priv/sched_config* to include the new resource name in the list of resources:

	resources: "ncpus, aoe, …,lic_foo"

and a new dynamic resource line telling the scheduler how to get the value for the resource:

	server_dyn_res: "lic_foo !/usr/local/bin/lic_avail_foo.sh"

send a HUP signal to the scheduler

	pkill -HUP pbs_sched

to test you can submit two jobs, one requesting more licenses than will ever be available and one requesting a sane value

	qsub -N too_many_lics -l lic_foo=99999 -- /bin/sleep 1m
	qsub -N resonable_lics -l lic_foo=1 -- /bin/sleep 1m

qstat should then show the first job queued, and the second running.

More detail in the PBS Professional documentaion https://help.altair.com/2022.1.0/PBS%20Professional/PBSAdminGuide2022.1.pdf#G8.1000354917 .

Note the potential for a race condition if the software takes a long time from being started to actually claiming a license out from its server. CD-Adapco's STAR-CCM+ is one example of this, with PBS correctly verifying that a (single) license was available, starting the CCM job, but CCM itself going through a long preamble before contactiong the license server to claim a license, during which time another job could be submitted then, because a license is still 'available' started by PBS. Solving this might require the use of license reservation features, if supported.
