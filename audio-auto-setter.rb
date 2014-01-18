require "coreaudio"
require "terminal-notifier"

# 入力文字列を名称に含むオーディオデバイスをデフォルト出力として設定
def set_interface(name)
	if !name
		return nil
	end

	devs = CoreAudio::devices

	tgt = devs.find{|dev| dev.name.index(name)}
	if !tgt
		return nil
	end

	CoreAudio::set_default_output_device(tgt)

	return tgt.name
end

def wait_till_turnon_interface(name)

	dev_name = nil
	while !dev_name
		dev_name = set_interface(name)
		sleep(1) if !dev_name
	end

	return dev_name
end

def notify_start(name)

	TerminalNotifier.notify(name, 
		:title => 'audio device setter',
		:subtitle => "Watching Audio Device")


	p "select default output audio interface #{name}"
end

def notify_interface(name)

	TerminalNotifier.notify(name, 
		:title => 'audio device setter',
		:subtitle => "Set Default Output Audio Device")


	p "select default output audio interface #{name}"
end

find_name = ARGV[0]

notify_start(find_name)
name = wait_till_turnon_interface(find_name)
notify_interface(name)



