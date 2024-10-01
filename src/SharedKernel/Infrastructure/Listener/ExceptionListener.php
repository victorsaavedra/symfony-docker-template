<?php

declare(strict_types=1);

namespace App\SharedKernel\Infrastructure\Listener;

use App\SharedKernel\Infrastructure\Exception\BadRequestException\GenericBadRequestException;
use App\SharedKernel\Infrastructure\Response\BadRequestResponse;
use App\SharedKernel\Infrastructure\Response\JsonApiResponseInterface;
use Symfony\Component\HttpKernel\Event\ExceptionEvent;

class ExceptionListener
{
    public function __construct(
        private readonly JsonApiResponseInterface $jsonApiResponse,
    ) {
    }

    public function onKernelException(ExceptionEvent $event): void
    {
        $exception = $event->getThrowable();

        if ($exception instanceof GenericBadRequestException) {
            $response = $this->jsonApiResponse->badRequest(
                new BadRequestResponse($exception->getMessage(), $exception->getCode())
            );

            $event->setResponse($response);
        }
    }
}
