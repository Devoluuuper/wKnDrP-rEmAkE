$(document).ready(function() {
    window.addEventListener('message', function (event) {
        var event = event.data;

        if (event.action === 'open') {
            $('#container').fadeIn()

            setTimeout(() => {
                $('#container').fadeOut(); $.post('https://kk-skills/timeout', JSON.stringify({}))
            }, 5000);

            $("#items").html("");

            $.each(event.skills, function(k, v){
                //$("#items").append(`
                //    <span class="text-xs font-normal inline-block py-1 px-2 uppercase rounded text-gray-200 bg-gray-800">${k}</span>
                //    <span class="px-2 text-xs leading-3 font-semibold rounded-full bg-red-100 text-red-800"><span x-text="skill.xp"></span>LVL ${v.lvl}</span>
                //<div class="mb-4"></div>
                //    <div class="overflow-hidden h-2 mb-4 text-xs flex rounded bg-blue-200">
                //        <div class="h-1.5 rounded-full bg-blue-500" style="width: ${v.progress}%"></div>
                //    </div>
                //`);

                $("#items").append(`
                    <div class="rounded-lg">
                        <div class="flex p-1 bg-slate-950 mt-2 rounded-lg">
                            <div class="bg-blue-500/75 w-[7.5rem] p-1 text-center rounded-l-md">
                                <span class="text-xs font-bold inline-block uppercase rounded text-gray-200">${k}</span>
                            </div>
                            <div class="relative flex-grow text-right p-1 font-bold">
                                <!-- Progress bar background with width based on progress -->
                                <div class="bg-blue-400/75 absolute top-0 bottom-0 left-0" style="width: ${v.progress}%;"></div>

                                <!-- Centered percentage text -->
                                <div class="absolute inset-0 flex items-center font-normal text-xs justify-center z-10 text-gray-200">
                                    ${v.progress}%
                                </div>
                            </div>
                            <div class="bg-blue-500/75 p-2 text-sm text-center rounded-r-md">
                                
                                <!-- LVL text (right-aligned) -->
                                <div class="relative z-10 text-gray-200">
                                    LVL: ${v.lvl}
                                </div>
                            </div>

                        </div>
                    </div>
                `);
            });
        }
    });
})