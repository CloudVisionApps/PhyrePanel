<div class="flex flex-col bg-gray-200 justify-center items-center h-screen text-center">
    <div class="w-[36rem]">
        <div>
            <h1 class="text-3xl font-bold">
                Welcome to PhyrePanel!
            </h1>
        </div>
        <div>
            <p class="text-xl">
                The simplest way to manage your websites.
            </p>
        </div>

        <div class="bg-white rounded-xl shadow p-4 my-6">
            <div>
                <h2 class="text-2xl">Let's make installation!</h2>
                <p>
                    Please fill in the form below to install PhyrePanel.
                </p>
            </div>
            <div class="m-auto w-1/2 my-6">
                <div class="space-y-3">

                   <div>
                       <x-bladewind::input required="true" label="Name" wire:model="name" />
                       @if($errors->has('name'))
                           <div class="text-red-500 text-sm">{{ $errors->first('name') }}</div>
                       @endif
                   </div>

                    <div>
                        <x-bladewind::input required="true" label="Email" wire:model="email" />
                        @if($errors->has('email'))
                            <div class="text-red-500 text-sm">{{ $errors->first('email') }}</div>
                        @endif
                    </div>

                    <div>
                        <x-bladewind::input required="true" label="Password" wire:model="password" type="password" />
                        @if($errors->has('password'))
                            <div class="text-red-500 text-sm">{{ $errors->first('password') }}</div>
                        @endif
                    </div>

                    <div>
                        <x-bladewind::input required="true" label="Confirm Password" wire:model="password_confirmation" type="password" />
                        @if($errors->has('password_confirmation'))
                            <div class="text-red-500 text-sm">{{ $errors->first('password_confirmation') }}</div>
                        @endif
                    </div>

                    <x-bladewind::button wire:click="install" size="small">
                        Install
                    </x-bladewind::button>

                </div>
            </div>
        </div>

        <div class="mt-6 text-sm">
            <p>
                <a href="https://PhyrePanel.com" class="text-blue-500 hover:text-blue-700">PhyrePanel</a> is a free and open-source web hosting control panel written in PHP.
            </p>
            <p>
                PhyrePanel is designed to work with either Apache or Nginx as a web server running on Ubuntu 20.04 LTS.
            </p>
        </div>
    </div>
</div>
