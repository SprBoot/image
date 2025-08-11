#!/bin/bash  
# 设置工作目录  
WORKSPACE="/home/jack/Docker/catkin_ws"  
MOVEIT_WS="/home/jack/Docker/ws_moveit"
ALOHA_WORKSPACE="/home/jack/Docker/aloha/act-main"   
# 启动VR设备进行数值读取  
gnome-terminal -- bash -c "  
    docker exec -it ros_noetic /bin/bash -c 'cd $WORKSPACE && source devel/setup.bash &&  
    roslaunch ros_tcp_endpoint endpoint.launch tcp_ip:=192.168.1.102 tcp_port:=10000';      
    exec bash" || { echo "Failed to launch ros_tcp_endpoint"; exit 1; }   
# 夹爪映射  
gnome-terminal -- bash -c "  
    docker exec -it ros_noetic /bin/bash -c 'cd $WORKSPACE && source devel/setup.bash &&
    rosrun arm_collision_checker data_to_inspire_gripper';      
    exec bash" || { echo "Failed to run data_to_inspire_gripper"; exit 1; }  
gnome-terminal -- bash -c "  
    docker exec -it ros_noetic /bin/bash -c 'cd $WORKSPACE && source devel/setup.bash &&   
    rosrun arm_collision_checker inspire_gripper_get_copen';    
    exec bash" || { echo "Failed to run inspire_gripper_get_copen"; exit 1; }  
# 连接实机  
gnome-terminal -- bash -c "  
    docker exec -it ros_noetic /bin/bash -c 'cd $WORKSPACE && source devel/setup.bash &&   
    roslaunch jack_robot demo_hw_real.launch';   
    exec bash" || { echo "Failed to launch demo_hw_real"; exit 1; }
# 启动VR远程进行配对  
gnome-terminal -- bash -c "  
    docker exec -it ros_noetic /bin/bash -c  'cd $MOVEIT_WS && source devel/setup.bash &&   
    roslaunch moveit_servo jack_quest_cpp_tele.launch';   
    exec bash" || { echo "Failed to launch jack_quest_cpp_tele"; exit 1; }
# 启动aloha算法窗口
gnome-terminal -- bash -c "  
    docker exec -it ros_noetic /bin/bash -c  'cd $ALOHA_WORKSPACE';   
    exec bash" || { echo "Failed to open aloha command"; exit 1; }   
