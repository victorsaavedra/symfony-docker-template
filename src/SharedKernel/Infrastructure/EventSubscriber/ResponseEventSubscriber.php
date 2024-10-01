<?php

declare(strict_types=1);

namespace App\SharedKernel\Infrastructure\EventSubscriber;

use App\SharedKernel\Infrastructure\Response\JsonApiResponseInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\ViewEvent;
use Symfony\Component\HttpKernel\KernelEvents;

final readonly class ResponseEventSubscriber implements EventSubscriberInterface
{
    public function __construct(
        private JsonApiResponseInterface $jsonApiResponse,
    ) {
    }

    public function onKernelView(ViewEvent $event): void
    {
        $controllerResult = $event->getControllerResult();

        $event->setResponse($this->jsonApiResponse->ok($controllerResult));
    }

    public static function getSubscribedEvents(): array
    {
        return [
            KernelEvents::VIEW => 'onKernelView',
        ];
    }
}
